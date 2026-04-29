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

output "backup_name" {
  value     = local.backup_name_safe
  sensitive = true
}

output "file_exists" {
  value = local.file_exists
}

output "file_directory" {
  value = local.file_dir
}

output "regions" {
  value = {
    combined = local.all_regions
    unique   = local.unique_regions
  }
}

output "cost_calculation" {
  value = {
    total  = local.total_cost
    final  = local.final_cost
  }
}

output "timestamp" {
  value = local.formatted_time
}

output "json_content" {
  value     = local.config_json
  sensitive = true
}

output "day12_bucket_name" {
  value = aws_s3_bucket.day12_bucket.bucket
}