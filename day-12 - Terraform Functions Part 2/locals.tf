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

############################################################
# Assignment 7: Backup Configuration
############################################################

locals {
  backup_name_safe = var.backup_name
}

############################################################
# Assignment 8: File Path Processing
############################################################

locals {
  file_exists = fileexists(var.file_path)
  file_dir    = dirname(var.file_path)
}

############################################################
# Assignment 9: Location Management
############################################################

locals {
  all_regions      = concat(var.primary_regions, var.secondary_regions)
  unique_regions   = toset(local.all_regions)
}

############################################################
# Assignment 10: Cost Calculation
############################################################

locals {
  total_cost   = sum(var.monthly_costs)
  adjusted     = local.total_cost - var.credit
  final_cost   = max(0, local.adjusted)
}

############################################################
# Assignment 11: Timestamp Management
############################################################

locals {
  current_time        = timestamp()
  formatted_time      = formatdate("YYYY-MM-DD hh:mm:ss", local.current_time)
  timestamp_safe_name = replace(local.current_time, ":", "-")
}

############################################################
# Assignment 12: File Content Handling
############################################################

locals {
  config_content = file(var.config_file)
  config_json    = jsondecode(local.config_content)
}