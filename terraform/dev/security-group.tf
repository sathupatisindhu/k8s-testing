module "eks-sg" {
  source = "../modules/securitygroup/"

  sg-name  = "eks-sg-1"
  vpc-id   = module.vpc.this_id
  env-name = var.env-name
  sg-rules = var.sg-rules

}
