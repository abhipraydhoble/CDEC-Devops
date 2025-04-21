resource "aws_instance" "vm" {
    ami = var.ami_id
    key_name = var.key
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.f1.name]
    user_data = <<-EOF
    #!/bin/bash
    sudo -i
    yum update -y
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo "Hello World" > /var/www/html/index.html
    EOF

    tags = {
        Name = "Web-Server"
    }
}

resource "aws_security_group" "f1" {

    name = "tf-day-2-sg"
    vpc_id = "vpc-0b513c39beed873c2"

    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = "80"
        to_port = "80"
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
       Name = "tf-sg"
    }
}



