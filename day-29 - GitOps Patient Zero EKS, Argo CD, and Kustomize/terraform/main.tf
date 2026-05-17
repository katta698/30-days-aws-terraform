locals {
  eks_azs = ["us-east-1a", "us-east-1b"]

  name = "${var.project_name}-${var.environment}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
    Day         = "29"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${local.name}-vpc"
  cidr = "10.29.0.0/16"

  azs             = local.eks_azs
  public_subnets  = ["10.29.1.0/24", "10.29.2.0/24"]
  private_subnets = ["10.29.11.0/24", "10.29.12.0/24"]

  enable_nat_gateway      = true
  single_nat_gateway      = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.20.0"

  name               = "${local.name}-eks"
  kubernetes_version = var.cluster_version

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns            = {}
    kube-proxy         = {}
    vpc-cni            = {}
    aws-ebs-csi-driver = {}
  }

  eks_managed_node_groups = {
    gitops_nodes = {
      name                = "gitops-ng"
      iam_role_name       = "day29-gitops-ng-role"
      create_access_entry = true

      instance_types = ["t3.medium"]

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

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

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