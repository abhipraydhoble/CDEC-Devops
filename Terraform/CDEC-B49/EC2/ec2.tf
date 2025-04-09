resource "aws_instance" "vm1" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key
    vpc_security_group_ids = ["sg-0573b38f4d0928041"]
    user_data = <<-EOF
    #!/bin/bash
    sudo -i 
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd 
    echo "Hello World" > /var/www/html/index.html

    EOF


    tags = {
        Name = "vm-01"
    }


# variables = store value
#data types : 
# number
# string
# bool
# map
# list
