output "subnet_id" {
  value = aws_subnet.pub.id
}

output "security_group_id" {
  value = aws_security_group.firewall.id
}
