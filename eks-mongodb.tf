module "mongodb" {
  source = "./modules/mongodb"

  project_name        = var.projectName
  vpc_id             = aws_vpc.main_vpc.id
  private_subnet_cidr = cidrsubnet("172.31.0.0/16", 4, 0)
  database_name      = "FoodOrder_Cardapio"

  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-node,
    aws_eks_addon.coredns
  ]
}

output "mongodb_service_ip" {
  value = module.mongodb.mongodb_service_ip
}

output "mongodb_namespace" {
  value = module.mongodb.mongodb_namespace
}
