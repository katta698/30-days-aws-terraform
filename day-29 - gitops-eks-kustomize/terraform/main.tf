# ==============================================================================
# DAY 29: GITOPS PATIENT ZERO - MAIN INFRASTRUCTURE CONFIGURATION
# ==============================================================================

# CRITICAL FIX: Explicitly exclude Local Zones (like us-east-1-dfw-1a)
data "aws_availability_zones" "available" {
  state = "available"
  
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"] # This restricts results to primary core AZs only
  }
}

locals {
  name    = "${var.project_name}-${var.environment}"
  eks_azs = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
    Day         = "29"
  }
}

# ... [Keep the rest of your module.vpc and module.eks configurations exactly the same] ...

# ------------------------------------------------------------------------------
# 1. NETWORKING LAYER (VPC, Subnets, and NAT Gateway Routing)
# ------------------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc"
  cidr = "10.29.0.0/16"

  azs             = local.eks_azs
  public_subnets  = ["10.29.1.0/24", "10.29.2.0/24"]
  private_subnets = ["10.29.11.0/24", "10.29.12.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# 2. COMPUTE LAYER (EKS Control Plane & Stable Managed Node Groups)
# ------------------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # Stable baseline bypassing v21 access entry registration bugs

  cluster_name    = "${local.name}-eks"
  cluster_version = var.cluster_version

  # CRITICAL NETWORK INTERACTION: Forces private worker nodes to talk to control plane locally
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    gitops_nodes = {
      name = "gitops-ng"

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      labels = {
        workload = "gitops"
      }
    }
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# 3. KUBERNETES INITIALIZATION LAYER (ArgoCD Namespace)
# ------------------------------------------------------------------------------
resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"

    labels = {
      "app.kubernetes.io/name" = "argocd"
      "managed-by"             = "terraform"
    }
  }

  depends_on = [module.eks]
}

# ------------------------------------------------------------------------------
# 4. DEPLOYMENT ENGINE LAYER (ArgoCD Helm Release Installation)
# ------------------------------------------------------------------------------
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.3.11" # Target stable chart version

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
        }
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace_v1.argocd]
}