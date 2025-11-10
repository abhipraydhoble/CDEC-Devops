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
## for_each(list)
```hcl
resource "aws_instance" "example" {
  for_each = toset(["Dev", "QA", "Prod"])  # Create instances for Dev, QA, and Prod

  ami           = "ami-0c4e27b0c52857dd6"
  instance_type = "t2.micro"

  tags = {
    Name = "Instance-${each.key}"  # Instance-Dev, Instance-QA, Instance-Prod
  }
}

output "public_ips" {
  value = { for key, instance in aws_instance.example : key => instance.public_ip }
}

```
## for_each(map)

```hcl
variable "instances" {
  default = {
    Dev  = "t2.micro"
    QA   = "t2.small"
    Prod = "t2.medium"
  }
}

resource "aws_instance" "example" {
  for_each = var.instances  # Create one instance for each key in the map

  ami           = "ami-0c4e27b0c52857dd6"
  instance_type = each.value  # Instance types from the map

  tags = {
    Name = "Instance-${each.key}"  # Instance-Dev, Instance-QA, Instance-Prod
  }
}

output "public_ips" {
  value = { for key, instance in aws_instance.example : key => instance.public_ip }
}
```


## Count 
```hcl
variable "tags_list" {
  default = ["Web", "App", "DB"]
}
resource "aws_instance" "example" {
  count = length(var.tags_list)  # Number of instances equals the list length

  ami           = "ami-0c4e27b0c52857dd6"
  instance_type = "t2.micro"

  tags = {
    Name = "Instance-${element(var.tags_list, count.index)}"
  }
}
output "public_ips" {
  value = [for instance in aws_instance.example : instance.public_ip]
}
```
