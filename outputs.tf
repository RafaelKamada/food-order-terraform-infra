output "eks_cluster_id" {
  value = aws_eks_cluster.eks-cluster.id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}
