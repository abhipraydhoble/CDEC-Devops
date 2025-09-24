variable "instance_type" {
  default = "t2.micro"

}

variable "ami_id" {
  default = "ami-08f52b2e87cebadd9"
}


output "lb_link" {
    value = aws_lb.my_lb.dns_name

}

