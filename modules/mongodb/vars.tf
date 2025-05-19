variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR da subnet privada"
  type        = string
}

variable "database_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "FoodOrder_Cardapio"
}
