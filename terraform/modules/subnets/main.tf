resource "aws_subnet" "this" {
    for_each = var.subnet-blocks

    vpc_id = var.vpc-id
    cidr_block = lookup(each.value, "cidr-block", null)
    availability_zone = lookup(each.value, "az", null)
    map_public_ip_on_launch = lookup(each.value, "map-public-ip", null)

    tags = {
      Name    = "${var.project}-${lookup(each.value, "subnet-name", null)}"
      Environment = "${var.env-name}"
    }

}

resource "aws_route_table_association" "this" {
    for_each = var.associate-route-table ? aws_subnet.this : {}

    subnet_id = each.value.id
    route_table_id = var.route-table-id
  
}
