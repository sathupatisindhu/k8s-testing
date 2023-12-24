## Creating the iam role for the eks cluster
data "aws_iam_policy_document" "ekscluster-role" {
  source_policy_documents = [file(var.ekscluster-role-json)]
}

resource "aws_iam_role" "eks_cluster" {
  name               = var.eks-cluster-rolename
  assume_role_policy = data.aws_iam_policy_document.ekscluster-role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}


##Creating the eks cluster
resource "aws_eks_cluster" "aws_eks" {
  for_each                  = var.eks-config

  name                      = lookup(each.value, "cluster-name", null)
  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = var.cluster-log-types
  version                   = var.eks-version

  vpc_config {
    endpoint_private_access = var.endpoint-private-access
    endpoint_public_access  = var.endpoint-public-access
    public_access_cidrs     = var.endpoint-public-access-cidrs
    security_group_ids      = [var.eks-security-group]
    subnet_ids              = var.eks-subnets
  }

  tags = {
    Name = lookup(each.value, "cluster-name", null)
    Environment = "${var.env-name}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    #aws_cloudwatch_log_group.cloudwatch_eks,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,

  ]
}

##EKS cluster add on for the vpccni
resource "aws_eks_addon" "vpc-cni" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}

  cluster_name  = each.value.name
  addon_name    = var.vpccni-name
  addon_version = var.vpccni-version
}

##EKS cluster add on for the coredns
resource "aws_eks_addon" "core-dns" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  cluster_name  = each.value.name
  addon_name    = var.coredns-name
  addon_version = var.coredns-version
}

##EKS cluster add on for the kubeproxy
resource "aws_eks_addon" "kube-proxy" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  
  cluster_name  = each.value.name
  addon_name    = var.kubeproxy-name
  addon_version = var.kubeproxy-version
}

# # OIDC provider
data "tls_certificate" "oidc_thumbprint" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  url = aws_eks_cluster.aws_eks[each.key].identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "oidc_cluster" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_thumbprint[each.key].certificates[0].sha1_fingerprint]
  url             = "${aws_eks_cluster.aws_eks[each.key].identity[0].oidc[0].issuer}"
}

# creating iam role and policy for cluster autoscaling
data "aws_iam_policy_document" "cluster-autoscaler-policy" {
  source_policy_documents = [file(var.eks-cluster-autoscaler-policy)]
}

resource "aws_iam_policy" "cluster-autoscaler-policy" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  name   = "AmazonEKSClusterAutoscalerPolicy_${each.value.name}"
  policy = data.aws_iam_policy_document.cluster-autoscaler-policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_cluster[each.key].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_cluster[each.key].arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_clusterautoscaler" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  name               = "AmazonEKSClusterAutoscalerRole_${each.value.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.key].json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterAutoscalerPolicy" {
  for_each      = var.eks-cluster-exists ? aws_eks_cluster.aws_eks : {}
  policy_arn = aws_iam_policy.cluster-autoscaler-policy[each.key].arn
  role       = aws_iam_role.eks_clusterautoscaler[each.key].name
}
