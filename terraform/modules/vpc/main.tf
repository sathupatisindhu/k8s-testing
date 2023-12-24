resource "aws_vpc" "this" {
    cidr_block = var.vpc-cidr-block
    instance_tenancy = var.instance-tenancy
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name    = var.project == null ? var.vpc-name : "${var.project}-${var.vpc-name}"
      Environment = "${var.env-name}"
    }

}
