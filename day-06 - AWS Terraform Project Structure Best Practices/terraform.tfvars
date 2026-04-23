project_name       = "aws-terraform-course"
environment        = "dev"
region             = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

tags = {
  Owner      = "Jay"
  Department = "Engineering"
  Purpose    = "TerraformLearning"
}