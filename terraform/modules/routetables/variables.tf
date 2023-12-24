variable "vpc-id" {
    description = "ID of the VPC"
    type = string  
}

variable "dest-cidr" {
    description = "Destination Cidr of the route"
    type = any
    default = "0.0.0.0/0" 
}

variable "gw-id" {
    description = "ID of the target gateway"
    type = string  
}

variable "env-name" {
    description = "Map of common tags"
    type = string
}

variable "rtb-name" {
    description = "Name of the route table"
    type = string
}

variable "project" {
    description = "Name of the project or client"
    type = string
}


