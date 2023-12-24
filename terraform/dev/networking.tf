module "vpc" {
  source = "../modules/vpc/"

  vpc-cidr-block = var.vpc-cidr
  vpc-name       = var.vpc-name
  env-name       = var.env-name
  project        = var.project == null ? var.vpc-name : var.project
}

module "private-subnets" {
  source         = "../modules/subnets/"
  subnet-blocks  = var.private-subnet-blocks
  vpc-id         = module.vpc.this_id
  route-table-id = module.private-route-table.id
  env-name       = var.env-name
  project        = var.project
}

module "public-subnets" {
  source         = "../modules/subnets/"
  subnet-blocks  = var.public-subnet-blocks
  vpc-id         = module.vpc.this_id
  route-table-id = module.public-route-table.id
  env-name       = var.env-name
  project        = var.project == null ? module.vpc.this_id : var.project
}

module "igw" {
  source   = "../modules/igw/"
  igw-name = var.igw-name
  vpc-id   = module.vpc.this_id
  env-name = var.env-name
  project  = var.project
}

module "ngw" {
  source           = "../modules/nat/"
  eip-name         = var.nat-eip-name
  nat-gateway-name = var.ngw-name
  subnet-id        = module.public-subnets.this_subnets_ids[0]
  env-name         = var.env-name
  project          = var.project
}

module "public-route-table" {
  source   = "../modules/routetables/"
  vpc-id   = module.vpc.this_id
  gw-id    = module.igw.igw_id
  rtb-name = var.public-rtb-name
  env-name = var.env-name
  project  = var.project
}

module "private-route-table" {
  source   = "../modules/routetables/"
  vpc-id   = module.vpc.this_id
  gw-id    = module.ngw.nat_gateway_id
  rtb-name = var.private-rtb-name
  env-name = var.env-name
  project  = var.project
}


