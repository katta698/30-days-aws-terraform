terraform {
  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-20/eks-custom-modules/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}