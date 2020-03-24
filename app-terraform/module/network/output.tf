output "ROUTE_NAT_ID" {
  value = aws_route_table.private-nat-route.id
}

output "WEBAPP_SUBNET_ID" {
  value = aws_subnet.webapp_subnet.id
}


output "PROXY_SUBNET_ID" {
  value = aws_subnet.proxy_subnet.id
}

output "PROXY_2_SUBNET_ID" {
  value = aws_subnet.proxy_2_subnet.id
}
