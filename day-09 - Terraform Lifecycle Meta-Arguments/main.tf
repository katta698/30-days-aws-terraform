data "aws_region" "current" {}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  common_tags = {
    Project     = "Day09-Terraform-Lifecycle"
    Owner       = "Jay"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  bucket_prefix = "${var.project_prefix}-${var.environment}-${random_string.suffix.result}"
}

# ------------------------------------------------------------
# 1. create_before_destroy
# This bucket uses a generated unique name.
# If replacement is needed, Terraform creates the new one first.
# ------------------------------------------------------------

resource "aws_s3_bucket" "zero_downtime_bucket" {
  bucket = "${local.bucket_prefix}-cbd"

  tags = merge(local.common_tags, {
    Name        = "create-before-destroy-demo"
    Lifecycle  = "create_before_destroy"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------
# 2. prevent_destroy
# This simulates a critical bucket.
# terraform destroy will fail while prevent_destroy is enabled.
# ------------------------------------------------------------

resource "aws_s3_bucket" "protected_bucket" {
  bucket = "${local.bucket_prefix}-protected"

  tags = merge(local.common_tags, {
    Name       = "protected-critical-bucket"
    Lifecycle = "prevent_destroy"
  })

  lifecycle {
    prevent_destroy = true
  }
}

# ------------------------------------------------------------
# 3. ignore_changes
# Terraform will ignore external tag changes to Owner.
# Good for tags modified by other tools or teams.
# ------------------------------------------------------------

resource "aws_s3_bucket" "ignore_changes_bucket" {
  bucket = "${local.bucket_prefix}-ignore"

  tags = merge(local.common_tags, {
    Name       = "ignore-changes-demo"
    Lifecycle = "ignore_changes"
    Owner     = "Jay"
  })

  lifecycle {
    ignore_changes = [
      tags["Owner"]
    ]
  }
}

# ------------------------------------------------------------
# 4. replace_triggered_by
# If the random pet name changes, this bucket is replaced.
# This shows dependency-based replacement.
# ------------------------------------------------------------

resource "random_pet" "deployment_version" {
  length = 2
}

resource "aws_s3_bucket" "replace_trigger_bucket" {
  bucket = "${local.bucket_prefix}-replace"

  tags = merge(local.common_tags, {
    Name              = "replace-trigger-demo"
    Lifecycle         = "replace_triggered_by"
    DeploymentVersion = random_pet.deployment_version.id
  })

  lifecycle {
    replace_triggered_by = [
      random_pet.deployment_version
    ]
  }
}

# ------------------------------------------------------------
# 5. precondition
# Terraform validates region before creating the bucket.
# ------------------------------------------------------------

resource "aws_s3_bucket" "precondition_bucket" {
  bucket = "${local.bucket_prefix}-precheck"

  tags = merge(local.common_tags, {
    Name       = "precondition-demo"
    Lifecycle = "precondition"
  })

  lifecycle {
    precondition {
      condition     = contains(var.allowed_regions, data.aws_region.current.name)
      error_message = "Deployment blocked. Region must be one of: ${join(", ", var.allowed_regions)}"
    }
  }
}

# ------------------------------------------------------------
# 6. postcondition
# Terraform checks after creation that required tags exist.
# ------------------------------------------------------------

resource "aws_s3_bucket" "postcondition_bucket" {
  bucket = "${local.bucket_prefix}-postcheck"

  tags = merge(local.common_tags, {
    Name       = "postcondition-demo"
    Lifecycle = "postcondition"
    Compliance = "Learning"
  })

  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "Environment")
      error_message = "Postcondition failed. Environment tag is missing."
    }

    postcondition {
      condition     = contains(keys(self.tags), "Compliance")
      error_message = "Postcondition failed. Compliance tag is missing."
    }
  }
}