variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDRs allowed to SSH"
  type        = list(string)
}

variable "name" {
  description = "Name prefix for the security groups"
  type        = string
}

