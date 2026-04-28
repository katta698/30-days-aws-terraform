output "assignment_1_formatted_project_name" {
  description = "Project name after using lower and replace."
  value       = local.formatted_project_name
}

output "assignment_2_common_tags" {
  description = "Final tags after using merge."
  value       = local.common_tags
}

output "assignment_3_final_bucket_name" {
  description = "S3 bucket name after using lower, replace, and substr."
  value       = local.final_bucket_name
}

output "assignment_4_allowed_ports" {
  description = "Ports after using split, for expression, tonumber, and join."
  value = {
    original_csv = var.allowed_ports_csv
    as_list      = local.allowed_ports_list
    as_numbers   = local.allowed_ports_number
    as_text      = local.allowed_ports_text
  }
}

output "assignment_5_selected_instance_size" {
  description = "Instance size selected using lookup."
  value       = local.selected_instance_size
}

output "assignment_6_validated_instance_type" {
  description = "Instance type validated using length, can, and regex."
  value       = var.selected_instance_type
}

output "created_resources" {
  description = "AWS resources created for Day 11."
  value = {
    vpc_id          = aws_vpc.day11_vpc.id
    bucket_name     = aws_s3_bucket.day11_bucket.bucket
    security_group  = aws_security_group.day11_sg.id
    ec2_instance_id = aws_instance.day11_ec2.id
  }
}