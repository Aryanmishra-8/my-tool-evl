provider "aws" {
  region     = "ap-south-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/24"
  vpc_name = "task-redis-vpc"

  public_subnets = {
    "public-1" = { cidr = "10.0.0.0/26", az = "ap-south-1a", name = "PUBLIC_SUBNET-1" }
    "public-2" = { cidr = "10.0.0.64/26", az = "ap-south-1b", name = "PUBLIC_SUBNET-2" }
  }

  private_subnets = {
    "private-1" = { cidr = "10.0.0.128/26", az = "ap-south-1a", name = "PRIVATE_SUBNET-1" }
    "private-2" = { cidr = "10.0.0.192/26", az = "ap-south-1b", name = "PRIVATE_SUBNET-2" }
  }
  nat_gateway_id = module.nat.nat_gateway_id

}

module "eip" {
  source = "./modules/eip"
}

module "nat" {
  source        = "./modules/nat_gateway"
  subnet_id     = module.vpc.public_subnet_ids[0] # ✅ Use index 0 for "public-1"
  allocation_id = module.eip.allocation_id
}

module "sg" {
  source            = "./modules/security_groups"
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = "10.0.0.0/24"
  allowed_ssh_cidrs = ["10.0.0.0/24"]
  name              = "redis"
}

module "bastion" {
  source             = "./modules/ec2_instance"
  ami                = "ami-0ea6bc719ab41b318"
  instance_type      = "t3.micro"
  key_name           = "terraform"
  subnet_id          = module.vpc.public_subnet_ids[0] # ✅ Use index 0 for "public-1"
  security_group_ids = [module.sg.public_sg_id]
  volume_size        = 8
  user_data          = ""

  name = "bastion_host"
}


module "redis1" {
  source             = "./modules/ec2_instance"
  ami                = "ami-0ea6bc719ab41b318"
  instance_type      = "t3.micro"
  key_name           = "terraform"
  subnet_id          = module.vpc.private_subnet_ids[0] # ✅ Use index 0 for "private-1"
  security_group_ids = [module.sg.private_sg_id]
  volume_size        = 30
  name               = "redis-1"

  # user_data          = file("${path.module}/scripts/redis-1.sh")
}

module "redis2" {
  source             = "./modules/ec2_instance"
  ami                = "ami-0ea6bc719ab41b318"
  instance_type      = "t3.micro"
  key_name           = "terraform"
  subnet_id          = module.vpc.private_subnet_ids[1] # ✅ Use index 1 for "private-2"
  security_group_ids = [module.sg.private_sg_id]
  volume_size        = 30
  name               = "redis-2"
  # user_data          = templatefile("${path.module}/scripts/redis-2.sh", { redis_1_private_ip = module.redis1.private_ip })

}

