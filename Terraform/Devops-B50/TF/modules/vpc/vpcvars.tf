variable "vpc_cidr_block" {
    type = string
  
}

variable "subnet_cidr_block" {
    type = list(string)
}

variable "az" {
    type = list (string)
  
}

variable "public_ip" {
    type = bool
  
}

variable "no_ip" {
    type = bool
  
}
