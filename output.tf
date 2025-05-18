// Outputs para recursos compartilhados
output "security_group_id" {
  description = "ID do Security Group do EKS"
  value       = aws_security_group.sg.id
  depends_on  = [aws_security_group.sg]
}

output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main_vpc.id
  depends_on  = [aws_vpc.main_vpc]
}
