locals {
  # Assignment 1: Project Naming
  # lower() converts text to lowercase.
  # replace() replaces matching text with another value.
  formatted_project_name = replace(lower(var.project_name), " ", "-")

  # Assignment 2: Resource Tagging
  # merge() combines multiple maps into one map.
  default_tags = {
    Owner      = var.owner
    Department = var.department
    ManagedBy  = "Terraform"
  }

  environment_tags = {
    Environment = var.environment
    Project     = local.formatted_project_name
  }

  common_tags = merge(local.default_tags, local.environment_tags)

  # Assignment 3: S3 Bucket Naming
  # substr() extracts part of a string.
  # lower() makes the name lowercase.
  # replace() removes or changes invalid characters.
  cleaned_bucket_name_step1 = lower(var.bucket_raw_name)
  cleaned_bucket_name_step2 = replace(local.cleaned_bucket_name_step1, " ", "-")
  cleaned_bucket_name_step3 = replace(local.cleaned_bucket_name_step2, "_", "-")
  final_bucket_name         = substr(local.cleaned_bucket_name_step3, 0, 50)

  # Assignment 4: Security Group Ports
  # split() converts comma-separated text into a list.
  # for expression transforms each value.
  # tonumber() converts string numbers into real numbers.
  # join() converts a list back into one string.
  allowed_ports_list   = split(",", var.allowed_ports_csv)
  allowed_ports_number = [for port in local.allowed_ports_list : tonumber(port)]
  allowed_ports_text   = join(", ", local.allowed_ports_list)

  # Assignment 5: Environment Lookup
  # lookup() gets a value from a map and allows a default fallback value.
  selected_instance_size = lookup(var.instance_type_by_environment, var.environment, "t3.micro")
}