variable "vpc_cidr" {}
variable "vpc_name" {}

variable "public_subnets" {
  description = "Map of public subnet configurations"
  type = map(object({
    cidr = string
    az   = string
    name = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnet configurations"
  type = map(object({
    cidr = string
    az   = string
    name = string
  }))
}
variable "nat_gateway_id" {
  description = "NAT Gateway ID for private route table"
  type        = string
}
