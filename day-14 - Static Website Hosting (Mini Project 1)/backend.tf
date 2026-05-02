terraform {
  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-14/static-website/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}