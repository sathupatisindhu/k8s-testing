resource "aws_internet_gateway" "this" {
    vpc_id = var.vpc-id

    tags = {
        Name = "${var.project}-${var.igw-name}"
        Environment = "${var.env-name}"
    }
}
