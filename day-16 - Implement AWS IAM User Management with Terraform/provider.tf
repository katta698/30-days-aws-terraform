provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "30DaysAwsTerraform"
      Day         = "16"
      ManagedBy   = "Terraform"
      Environment = "Demo"
      Owner       = "Jayanth"
    }
  }
}