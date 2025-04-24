resource "aws_vpc" "net" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "TF-Modules"
    }
  
}

resource "aws_subnet" "pub"{
    vpc_id = aws_vpc.net.id
    cidr_block = var.subnet_cidr_block[0]
    availability_zone = var.az[0]
    map_public_ip_on_launch = var.public_ip
    tags = {
        Name = "Public-Subnet"
    }

}

resource "aws_subnet" "pri"{
    vpc_id = aws_vpc.net.id 
    cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.az[1]
    map_public_ip_on_launch = var.no_ip
    tags = {
        Name = "Private-Subnet"
    }
}

# create internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.net.id 
    tags = {
        Name = "igw-tf-modules"
    }
}
# create eip for nat-gw
resource "aws_eip" "fix" {
    domain = "vpc"
}
# create nat
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.fix.id
  subnet_id     = aws_subnet.pub.id
}
# route table for private sub also add nat-gw here
resource "aws_route_table" "rt-1" {
    vpc_id = aws_vpc.net.id 
    tags = {
      Name = "Private-RT-TF"
    }

    route {
        nat_gateway_id = aws_nat_gateway.gw.id
        cidr_block = "0.0.0.0/0"
    }
  
}
# associate private subnet with route table
resource "aws_route_table_association" "new" {
    subnet_id = aws_subnet.pri.id
    route_table_id = aws_route_table.rt-1.id
  
}

# create route table for public also add nat-gw
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.net.id
  tags = {
    Name = "Public-RT-TF"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
# associate public subnet with route table
resource "aws_route_table_association" "name" {
    route_table_id = aws_route_table.rt.id
    subnet_id = aws_subnet.pub.id
  
}


# create security group
resource "aws_security_group" "firewall" {
    name = "my-firewall-tf"
    vpc_id = aws_vpc.net.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
