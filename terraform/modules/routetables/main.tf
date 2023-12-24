resource "aws_route_table" "this" {
    vpc_id = var.vpc-id
    route {
        cidr_block = var.dest-cidr
        gateway_id = var.gw-id
    }
    tags = {
        Name = "${var.project}-${var.rtb-name}"
        Environment = "${var.env-name}"
    }
}
