# Outputs para MongoDB
output "mongodb_endpoint" {
  description = "Endpoint do MongoDB no EKS"
  value = kubernetes_service.mongodb.status[0].load_balancer[0].ingress[0].hostname
}

output "mongodb_port" {
  description = "Porta do MongoDB"
  value = 27017
}

output "mongodb_username" {
  description = "Usuário do MongoDB"
  value = "dev_user"
}

output "mongodb_password" {
  description = "Senha do MongoDB"
  value = var.mongodb_admin_password
  sensitive = true
}

output "mongodb_database" {
  description = "Nome do banco de dados do MongoDB"
  value = "FoodOrder_Cardapio"
}
