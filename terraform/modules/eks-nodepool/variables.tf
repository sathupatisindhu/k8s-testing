variable "nodegroup-config" {
  description = "config of the EKS cluster"
  type = any
}

variable "eks-node-subnets" {
  description = "subnets for the node group"
}

variable "workernode-role-json" {
  description = "path of the workernode role"
}

variable "eks-workernode-rolename" {
  description = "name for the workernode role"
  type        = string
}

variable "workernode-albpolicy" {
  description = "Name of the json file"
}

variable "eksworker-albpolicy" {
  description = "Name of the alb policy that will attach to the worker nodes"
}

variable "workernode-alb-additionalpolicy" {
  description = "Name of the json file"
}

variable "eksworker-albpolicy2" {
  description = "Name of the alb policy that will attach to the worker nodes"
}

variable "env-name" {
    description = "Map of common tags"
    type = string
}


variable "create" {
  description = "Controls if EKS resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "eks_cluster_name" {

}
