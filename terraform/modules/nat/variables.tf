variable "nat-gateway-name" {
  description = "name of the natgatway"
  type        = string
}

variable "eip-name" {
    description = "Elastic IP name"
    type = string  
}

variable "subnet-id" {
  description = "Public Subnet ID of the subnet in which to place the gateway"
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
