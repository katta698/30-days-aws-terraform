output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "argocd_namespace" {
  description = "Argo CD namespace"
  value       = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "argocd_password_command" {
  description = "Command to get initial Argo CD admin password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "argocd_service_command" {
  description = "Command to get Argo CD LoadBalancer"
  value       = "kubectl get svc argocd-server -n argocd"
}