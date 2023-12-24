resource "aws_security_group" "this" {
    name = var.sg-name
    vpc_id = var.vpc-id

    tags = {
        Environment = "${var.env-name}"
    }

}

resource "aws_security_group_rule" "this" {
    for_each = var.sg-rules

    type = lookup(each.value, "rule-type", null)
    from_port = lookup(each.value, "from-port", null)
    to_port = lookup(each.value, "to-port", null)
    protocol = lookup(each.value, "rule-protocol", null)
    cidr_blocks = [lookup(each.value, "source-cidr-block", null)]
    source_security_group_id = lookup(each.value, "source-sg", null)
    security_group_id = aws_security_group.this.id
}
