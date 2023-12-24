variable "sg-name" {
    description = "Name of the Security Group"
    type = string 
}

variable "vpc-id" {
    description = "ID of the VPC"
    type = string  
}

variable "env-name" {
    description = "Common Tag"
    type = string  
}

variable "sg-rules" {
    description = "security group rules"
    type = any
}
