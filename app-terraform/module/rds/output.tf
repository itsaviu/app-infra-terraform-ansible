output "RDS_HOST_ENDPOINT" {
  value = aws_db_instance.psql-db.endpoint
}
