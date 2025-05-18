variable "regionDefault" {
  default = "us-east-1"
}

variable "projectName" {
  default = "EKS-FOOD-ORDER-API"
}

variable "labRole" {
  default = "arn:aws:iam::276201098979:role/LabRole"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}

variable "nodeGroup" {
  default = "food-order-api-node-group"
}

variable "instanceType" {
  default = "t3.medium"
}

variable "principalArn" {
  default = "arn:aws:iam::276201098979:role/voclabs"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "private_subnet_ids" {
  description = "Lista de subnets privadas"
  default     = []
}

variable "environment" {
  default = "Production-2"
}


# Variáveis MongoDB
variable "mongodb_name" {
  default = "food-order-mongodb"
}

variable "mongodb_instance_type" {
  default = "db.t3.small"
}

variable "mongodb_allocated_storage" {
  default = 20
}

variable "mongodb_backup_retention_period" {
  default = 7
}

variable "mongodb_subnet_group_name" {
  description = "Nome do Subnet Group criado na infraestrutura principal"
  default = "rds_subnet_group"  # Mantendo o mesmo padrão do RDS
}

variable "mongodb_admin_password" {
  description = "Password for MongoDB admin user (only for development)"
  type        = string
  sensitive   = true
  default     = "dev123"  # Senha simples para ambiente de desenvolvimento
}

variable "eks_cluster_db" {
  description = "Nome do cluster EKS"
  default     = "EKS-FOOD-ORDER-DB"
}
