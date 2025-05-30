output "eks_cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "eks_cluster_certificate_authority_0_data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}
