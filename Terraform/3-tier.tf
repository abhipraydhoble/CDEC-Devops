resource  "aws_vpc" "vnet" {
    cidr_block = "192.168.0.0/16"
    tags = {
        Name = "vpc-three-tier"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "192.168.0.0/24"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Public-Subnet"
    }
}

resource "aws_subnet" "private-tom" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "ap-southeast-1b"
    map_public_ip_on_launch = false
    tags = {
        Name = "Private-Subnet-Tomcat"
    }
}


resource "aws_subnet" "private-db" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "ap-southeast-1c"
    map_public_ip_on_launch = false
    tags = {
        Name = "Private-Subnet-Database"
    }
}

resource "aws_internet_gateway" "igw-demo" {

    vpc_id = aws_vpc.vnet.id
    tags = {
        Name = "igw-three-tier"
    }
}

resource "aws_route_table" "RT-public" {
    vpc_id = aws_vpc.vnet.id
    tags = {
        Name = "RT-public"
    }
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-demo.id
    }
}

resource "aws_route_table" "RT-private" {
    vpc_id = aws_vpc.vnet.id
    tags = {
        Name = "RT-private"
    }
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-vpc-tf.id
}
}

resource "aws_eip" "eip" {
 domain = "vpc"
}


resource "aws_nat_gateway" "nat-vpc-tf" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public.id
}
resource "aws_route_table_association" "rt-public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.RT-public.id
}

resource "aws_route_table_association" "rt-private" {
    subnet_id = aws_subnet.private-tom.id
    route_table_id = aws_route_table.RT-private.id
}
resource "aws_route_table_association" "rt-private-db" {
    subnet_id = aws_subnet.private-db.id
    route_table_id = aws_route_table.RT-private.id
}

resource "aws_security_group" "demo-sg" {
    name = "three-tier-sg"
    description = "allow ports ssh db tomcat and http to instance"
    vpc_id = aws_vpc.vnet.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

      ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "three-tier-sg"
    }
}


resource "aws_instance" "vm-nginx" {
    ami = "ami-0afc7fe9be84307e4"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    key_name = "three-tier"
    
    tags = {
        Name = "Nginx-Instance"
    }
    user_data = <<-EOF
    #!/bin/bash
    sudo -i
    yum update -y
    yum install nginx -y
    systemctl start nginx
    systemctl enable nginx
    EOF

}


resource "aws_instance" "vm-db" {
    ami = "ami-0afc7fe9be84307e4"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private-db.id
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    key_name = "three-tier"
    
    tags = {
        Name = "Database-Instance"
    }
}

resource "aws_instance" "vm-tom" {
    ami = "ami-0afc7fe9be84307e4"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private-tom.id
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    key_name = "three-tier"
    
    tags = {
        Name = "Tomcat-Instance"
    }
}
resource "aws_db_subnet_group" "db-subnet" {
  name = "db-subnet"
  subnet_ids = [aws_subnet.private-tom.id,aws_subnet.private-db.id]
}

resource "aws_db_instance" "rds" {
  allocated_storage = 20
  db_name = "database1"
  engine = "mariadb"
  engine_version = "10.11.6"
  username = "admin"
  password = "Passwd123$"
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  vpc_security_group_ids = [aws_security_group.demo-sg.id]

  tags = {
    Name = "DB-Instance"
  }
}
