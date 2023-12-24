variable "ekscluster-role-json" {
  description = "path of the ekscluster role"
}

variable "eks-cluster-rolename" {
  description = "name of the cluster rolename"
  type        = string
}

variable "eks-config" {
  description = "config of the EKS cluster"
  type = any
}

variable "cluster-log-types" {
  description = "cluster log type"
}

variable "eks-version" {
  description = "eks cluster version"
}

variable "endpoint-private-access" {
  description = "private access endpoint"
  type        = bool
}

variable "endpoint-public-access" {
  description = "public access endpoint"
  type        = bool
}

variable "endpoint-public-access-cidrs" {
  description = "ip address for public to access endpoint"
}

variable "eks-security-group" {
  description = "security group for the eks cluster"
}

variable "eks-subnets" {
  description = "subnets for assinging to the eks"
}

variable "vpccni-name" {
  description = "name of the vpccni"
  type        = string
}

variable "coredns-name" {
  description = "name of the vpccni"
  type        = string
}

variable "kubeproxy-name" {
  description = "name of the vpccni"
  type        = string
}

variable "eks-cluster-autoscaler-policy" {
  description = "Name of the eks cluster autoscaler role"
}

variable "vpccni-version" {
  description = "version number for vpccni"
}

variable "coredns-version" {
  description = "version number for coredns"
}

variable "kubeproxy-version" {
  description = "version number for kubeproxy"
}

variable "env-name" {
    description = "Map of common tags"
    type = string
}

variable "eks-cluster-exists" {
  description = "Bool to check if cluster exists"
  type = bool
  default = true

}
variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "create" {
  description = "Controls if EKS resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}
