output "nat_gateway_id" {
    description = "ID of the NAT Gateway"
    value = aws_nat_gateway.this.id 
}

output "nat_elastic_ip" {
    description = "Elastic IP address attached to NAT"
    value = aws_eip.nat-eip.address  
}
