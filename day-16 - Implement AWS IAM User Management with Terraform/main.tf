locals {
  users = csvdecode(file("${path.module}/users.csv"))

  users_map = {
    for user in local.users :
    lower("${substr(user.first_name, 0, 1)}${user.last_name}") => user
  }
}

resource "aws_iam_user" "users" {
  for_each = local.users_map

  name = each.key
  path = "/users/"

  force_destroy = true

  tags = {
    DisplayName = "${each.value.first_name} ${each.value.last_name}"
    FirstName   = each.value.first_name
    LastName    = each.value.last_name
    Department  = each.value.department
    JobTitle    = each.value.job_title
  }
}

resource "aws_iam_user_login_profile" "users" {
  for_each = aws_iam_user.users

  user                    = each.value.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required
    ]
  }
}