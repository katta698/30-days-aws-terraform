bucket         = "jay-terraformstate-bucket"
key            = "day-30/dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-dev-lock-table" # Ensure this DynamoDB table exists for locking