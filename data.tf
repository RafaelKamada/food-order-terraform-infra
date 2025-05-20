# Data source para a VPC existente
data "aws_vpc" "existing" {
  id = "vpc-0ac67343fd6d2d069"  # Substitua pelo ID da sua VPC existente se for diferente
}

# Data source para as sub-redes privadas existentes
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}

# Data source para o security group existente
data "aws_security_group" "existing" {
  name = "SG-EKS-FOOD-ORDER-DB"
}

# Data source para o cluster EKS (usado por outros recursos)
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks-cluster.name
}