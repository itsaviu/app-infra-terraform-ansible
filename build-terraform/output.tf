output "VPC" {
  value = aws_vpc.build-vpc.id
}

output "ROUTE_TABLE" {
  value = aws_route_table.build-route.id
}

output "INSTANCE_PUBLIC_IP" {
  value = aws_instance.build_instance.public_ip
}

output "INSTANEC_SECURITY_GROUP" {
  value = aws_security_group.sg.id
}

output "INSATNCE_SUBNET" {
  value = aws_subnet.build-subnet.id
}
