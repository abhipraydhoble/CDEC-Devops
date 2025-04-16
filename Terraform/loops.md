````
variable "instance_names" {
  default = ["web", "app", "db"]
}

resource "aws_instance" "example" {
  for_each = toset(var.instance_names)

  ami           = "ami-123456"
  instance_type = "t2.micro"
  tags = {
    Name = each.value
  }
}

````
````
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-123456" # Use a valid AMI
  instance_type = "t2.micro"

  tags = {
    Name = "server-${count.index}"
  }
}
````

````
# locals.tf
locals {
  environment = "dev"
  owner       = "sagar"
  instance    = "t2.micro"
}
````
````
# main.tf
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = local.instance

  tags = {
    Owner       = local.owner
    Environment = local.environment
  }
}
````



