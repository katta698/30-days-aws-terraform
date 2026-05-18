bucket         = "jay-terraformstate-bucket"
key            = "day-30/prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-prod-lock-table" # Ensure this DynamoDB table exists for locking