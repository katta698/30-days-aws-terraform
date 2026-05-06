terraform {
  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "day-18/simple-image-processor/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}