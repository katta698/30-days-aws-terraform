############################################################
# Day 11–12 Terraform Functions
# Locals grouped by assignment for clarity
############################################################

############################################################
# Assignment 1: Project Naming
# Functions: lower(), replace()
############################################################

locals {
  formatted_project_name = replace(lower(var.project_name), " ", "-")
}

############################################################
# Assignment 2: Resource Tagging
# Function: merge()
############################################################

locals {
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
}

############################################################
# Assignment 3: S3 Bucket Naming
# Functions: lower(), replace(), substr()
############################################################

locals {
  cleaned_bucket_name_step1 = lower(var.bucket_raw_name)
  cleaned_bucket_name_step2 = replace(local.cleaned_bucket_name_step1, " ", "-")
  cleaned_bucket_name_step3 = replace(local.cleaned_bucket_name_step2, "_", "-")
  final_bucket_name         = substr(local.cleaned_bucket_name_step3, 0, 50)
}

############################################################
# Assignment 4: Security Group Ports
# Functions: split(), for expression, tonumber(), join()
############################################################

locals {
  allowed_ports_list   = split(",", var.allowed_ports_csv)
  allowed_ports_number = [for port in local.allowed_ports_list : tonumber(port)]
  allowed_ports_text   = join(", ", local.allowed_ports_list)
}

############################################################
# Assignment 5: Environment Lookup
# Function: lookup()
############################################################

locals {
  selected_instance_size = lookup(var.instance_type_by_environment, var.environment, "t3.micro")
}

############################################################
# Assignment 7: Backup Configuration
# Function: endswith() is used in variables.tf validation
############################################################

locals {
  backup_name_safe = var.backup_name
}

############################################################
# Assignment 8: File Path Processing
# Functions: fileexists(), dirname()
############################################################

locals {
  file_exists = fileexists(var.file_path)
  file_dir    = dirname(var.file_path)
}

############################################################
# Assignment 9: Location Management
# Functions: concat(), toset()
############################################################

locals {
  all_regions    = concat(var.primary_regions, var.secondary_regions)
  unique_regions = toset(local.all_regions)
}

############################################################
# Assignment 10: Cost Calculation
# Functions: sum(), max(), abs()
############################################################

locals {
  total_cost = sum(var.monthly_costs)
  credit_abs = abs(var.credit)
  adjusted   = local.total_cost - local.credit_abs
  final_cost = max(0, local.adjusted)
}

############################################################
# Assignment 11: Timestamp Management
# Functions: timestamp(), formatdate(), replace()
############################################################

locals {
  current_time        = timestamp()
  formatted_time      = formatdate("YYYY-MM-DD hh:mm:ss", local.current_time)
  timestamp_safe_name = lower(formatdate("YYYYMMDDhhmmss", local.current_time))
}

############################################################
# Assignment 12: File Content Handling
# Functions: file(), jsondecode()
############################################################

locals {
  config_content = file(var.config_file)
  config_json    = jsondecode(local.config_content)
}