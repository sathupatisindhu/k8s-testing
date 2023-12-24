module "eks" {
  source = "../modules/eks/"

  eks-config                    = var.eks-config
  ekscluster-role-json          = var.ekscluster-role-json
  eks-cluster-rolename          = var.eks-cluster-rolename
  cluster-log-types             = var.cluster-log-types
  eks-version                   = var.eks-version
  endpoint-private-access       = var.endpoint-private-access
  endpoint-public-access        = var.endpoint-public-access
  endpoint-public-access-cidrs  = var.endpoint-public-access-cidrs
  eks-security-group            = module.eks-sg.this_id
  eks-subnets                   = module.public-subnets.this_subnets_ids
  vpccni-name                   = var.eks-vpccni-name
  coredns-name                  = var.eks-coredns-name
  kubeproxy-name                = var.eks-kubeproxy-name
  eks-cluster-autoscaler-policy = var.eks-cluster-autoscaler-policy
  vpccni-version                = var.eks-vpccni-version
  coredns-version               = var.eks-coredns-version
  kubeproxy-version             = var.eks-kubeproxy-version
  env-name                      = var.env-name

}


module "eks-nodepool" {
  source = "../modules/eks-nodepool/"

  eks_cluster_name                = module.eks.cluster_name
  nodegroup-config                = var.nodegroup-config
  eks-node-subnets                = module.public-subnets.this_subnets_ids
  workernode-role-json            = var.workernode-role-json
  eks-workernode-rolename         = var.eks-workernode-rolename
  workernode-albpolicy            = var.eks-workernode-albpolicy
  eksworker-albpolicy             = var.eks-eksworker-albpolicy
  workernode-alb-additionalpolicy = var.eks-workernode-alb-additionalpolicy
  eksworker-albpolicy2            = var.eks-eksworker-albpolicy2
  env-name                        = var.env-name

}
