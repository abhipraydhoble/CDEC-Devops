resource "aws_instance" "vm-2" {
    ami = var.ami_id 
    instance_type = var.instance_type
    key_name = var.key
    vpc_security_group_ids = [var.security_group_id]
    subnet_id = var.subnet_id


    tags = {
        Name = "public-vm"
    }
  
}

resource "aws_instance" "vm-1" {
    ami = var.ami_id 
    instance_type = var.instance_type
    key_name = var.key
    vpc_security_group_ids = [var.security_group_id]
    subnet_id = var.subnet_id

    tags = {
        Name = "private-vm"
    }
  
}


