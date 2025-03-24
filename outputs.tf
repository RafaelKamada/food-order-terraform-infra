output "eks_cluster_name" {
  value = aws_db_instance.rds_postgres.endpoint
}

output "security_group_id" {
  value = aws_security_group.sg.id
}
