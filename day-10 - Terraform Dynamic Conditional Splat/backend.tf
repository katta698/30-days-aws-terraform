terraform {
  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-10/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}