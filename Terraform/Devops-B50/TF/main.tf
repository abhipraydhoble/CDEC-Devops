module "vpc" {
    source = "./modules/vpc"
    vpc_cidr_block = "192.168.0.0/16"
    subnet_cidr_block = ["192.168.0.0/22", "192.168.4.0/22"]
    az = ["ap-southeast-1a", "ap-southeast-1b"]
    public_ip =  true
    no_ip = false
  
}

module "ec2" {
    source = "./modules/ec2"
    ami_id =  "ami-05ab12222a9f39021"
    instance_type =  "t2.micro"
    key = "laptop-key"
    security_group_id =  module.vpc.security_group_id
    subnet_id = module.vpc.subnet_id
}
