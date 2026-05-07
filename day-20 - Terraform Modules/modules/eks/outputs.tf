output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster.id
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_names" {
  value = [for node_group in aws_eks_node_group.this : node_group.node_group_name]
}

output "oidc_provider_arn" {
  value = try(aws_iam_openid_connect_provider.this[0].arn, null)
}

output "oidc_provider_url" {
  value = try(aws_iam_openid_connect_provider.this[0].url, null)
}