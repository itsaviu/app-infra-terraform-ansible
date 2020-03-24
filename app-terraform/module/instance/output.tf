output "INSTANCE_SG" {
  value = aws_security_group.instance_sg.id
}


output "INSTANCE_ID" {
  value = aws_instance.instance.id
}

output "PRIVATE_IP" {
  value = aws_instance.instance.private_ip
}
