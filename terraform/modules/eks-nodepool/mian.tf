##Creating the IAM role for the worker nodes
data "aws_iam_policy_document" "eksworkernode-role" {
  source_policy_documents = [file(var.workernode-role-json)]
}

resource "aws_iam_role" "eks_nodes" {
  name               = var.eks-workernode-rolename
  assume_role_policy = data.aws_iam_policy_document.eksworkernode-role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

data "aws_iam_policy_document" "workernode-albpolicy" {
  source_policy_documents = [file(var.workernode-albpolicy)]
}

resource "aws_iam_role_policy" "eksworker-policy" {
  name   = var.eksworker-albpolicy
  role   = aws_iam_role.eks_nodes.id
  policy = data.aws_iam_policy_document.workernode-albpolicy.json
}

data "aws_iam_policy_document" "workernode-albpolicy2" {
  source_policy_documents = [file(var.workernode-alb-additionalpolicy)]
}

resource "aws_iam_role_policy" "eksworker-policy2" {
  name   = var.eksworker-albpolicy2
  role   = aws_iam_role.eks_nodes.id
  policy = data.aws_iam_policy_document.workernode-albpolicy2.json
}

##Creating the worker nodes for the EKS cluster
resource "aws_eks_node_group" "node" {
  for_each        = var.nodegroup-config

  cluster_name    = var.eks_cluster_name[0]
  node_group_name = lookup(each.value, "node_group_name", null)
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.eks-node-subnets
  instance_types  = lookup(each.value, "instance_types", null)
  ami_type        = lookup(each.value, "ami_type", null)
  capacity_type   = lookup(each.value, "capacity_type", null)
  disk_size       = lookup(each.value, "disksize", null)

  remote_access {
    ec2_ssh_key = lookup(each.value, "keypair", null)
  }

  scaling_config {
    desired_size = lookup(each.value, "desiredsize", null)
    max_size     = lookup(each.value, "maxsize", null)
    min_size     = lookup(each.value, "minsize", null)
  }

  labels = {
    Name = "${each.value.node_group_name}-worker-node"
  }

  tags = {
    Name = "${each.value.node_group_name}-worker-nodes"
    Environment = "${var.env-name}"
  }


  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy,
  ]
}

