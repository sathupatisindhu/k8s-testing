env-name = "test-research-development"
project  = "test-dev"


#VPC and subnets
vpc-cidr = "10.10.0.0/16"
vpc-name = "vpc"

private-subnet-blocks = {
  pri_subnet_1 = {
    cidr-block  = "10.10.128.0/18"
    az          = "us-west-2a"
    subnet-name = "private-subnet-1"
  },
  pri_subnet_2 = {
    cidr-block  = "10.10.192.0/18"
    az          = "us-west-2b"
    subnet-name = "private-subnet-1"
  }
}
public-subnet-blocks = {
  pub_subnet_1 = {
    cidr-block    = "10.10.32.0/19"
    az            = "us-west-2a"
    subnet-name   = "public-subnet-1"
    map-public-ip = true
  },
  pub_subnet_2 = {
    cidr-block    = "10.10.64.0/19"
    az            = "us-west-2c"
    subnet-name   = "public-subnet-1"
    map-public-ip = true
  }
}

#IGW, NGW and EIP
igw-name     = "vpc-igw"
ngw-name     = "vpc-ngw"
nat-eip-name = "nat-eip"

#Routetables
private-rtb-name = "private-rtb"
public-rtb-name  = "public-rtb"

# Security Group Rules
sg-rules = {
  sg-rule-1 = {
    rule-type         = "ingress"
    from-port         = "443"
    to-port           = "443"
    rule-protocol     = "tcp"
    source-cidr-block = "0.0.0.0/0"
  }
}

## security group
app-sg-name = "appserver-private"

# #EKS
eks-config = {
  eks-cluster-1 = {
    cluster-name = "master"
  }
}

nodegroup-config = {
  node-group-1 = {
    node_group_name = "node-1",
    instance_types  = ["t3.small"],
    ami_type        = "AL2_x86_64"
    capacity_type   = "ON_DEMAND",
    disksize        = 10,
    keypair         = "key-pair",
    desiredsize     = 2,
    maxsize         = 3,
    minsize         = 2
  },
  node-group-2 = {
    node_group_name = "node-2",
    instance_types  = ["t3a.small"],
    ami_type        = "AL2_x86_64"
    capacity_type   = "ON_DEMAND",
    disksize        = 10,
    keypair         = "key-pair",
    desiredsize     = 2,
    maxsize         = 3,
    minsize         = 2
  }
}

ekscluster-role-json                = "../dev/jsons/ekscluster-role.json"
eks-cluster-rolename                = "dev-eks-cluster-role"
cluster-log-types                   = ["api", "audit"]
eks-version                         = "1.23"
endpoint-private-access             = false
endpoint-public-access              = true
endpoint-public-access-cidrs        = ["0.0.0.0/0"]
workernode-role-json                = "../dev/jsons/workernode-role.json"
eks-workernode-rolename             = "dev-eks-worker-node-role"
eks-vpccni-name                     = "vpc-cni"
eks-kubeproxy-name                  = "kube-proxy"
eks-coredns-name                    = "coredns"
eks-workernode-albpolicy            = "../dev/jsons/workernode-albpolicy.json"
eks-eksworker-albpolicy             = "dev-eks-AWSLoadBalancerControllerIAMPolicy"
eks-workernode-alb-additionalpolicy = "../dev/jsons/workernode-albpolicy-additionalpolicy.json"
eks-cluster-autoscaler-policy       = "../dev/jsons/cluster-autoscaler-policy.json"
eks-eksworker-albpolicy2            = "dev-eks-AWSLoadBalancerControllerAdditionalIAMPolicy"
eks-vpccni-version                  = "v1.10.4-eksbuild.1"
eks-coredns-version                 = "v1.8.7-eksbuild.2"
eks-kubeproxy-version               = "v1.23.7-eksbuild.1"

