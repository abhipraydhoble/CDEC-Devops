module "ec2" {
  source  = "./ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  instance_name = var.instance_name
  }

  module "vpc" {
    source = "./vpc"
    vpc_cidr_block = var.vpc_cidr_block
    vpc_name = var.vpc_name
    subnet_cidr_block = var.subnet_cidr_block
    subnet_az = var.subnet_az
    public_ip = var.public_ip
    subnet_name = var.subnet_name
    ports = var.ports
    igw_name = var.igw_name
  }
