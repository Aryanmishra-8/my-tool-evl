variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}

variable "name" {
  description = "Instance Name tag"
  type        = string
}

