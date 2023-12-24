variable "vpc-id" {
    description = "ID of the VPC"
    type = string  
}

variable "igw-name" {
    description = "Name of the internet gateway"  
    type = string
}

variable "env-name" {
    description = "Map of common tags"
    type = string
}

variable "project" {
    description = "Name of the project or client"
    type = string
}
