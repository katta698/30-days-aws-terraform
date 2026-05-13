output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_2.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "workspace_note" {
  value = "This infrastructure was managed through HCP Terraform Cloud workspace: day26-terraform-cloud"
}