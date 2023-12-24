resource "aws_eip" "nat-eip" {
    vpc = true
    tags = {
        Name = "${var.project}-${var.eip-name}"
        Environment = "${var.env-name}"
    }
  
}

resource "aws_nat_gateway" "this" {
    allocation_id = aws_eip.nat-eip.id
    subnet_id = var.subnet-id
    tags = {
        Name = "${var.project}-${var.nat-gateway-name}"
        Environment = "${var.env-name}"
    }  
}
