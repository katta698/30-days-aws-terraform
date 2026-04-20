provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "jay-day3-s3-bucket-123456"

  tags = {
    Name        = "Day3Bucket"
    Environment = "Learning"
  }
}