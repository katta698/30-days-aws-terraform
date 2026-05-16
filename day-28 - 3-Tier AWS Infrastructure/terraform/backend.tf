terraform {
  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-28v2/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}