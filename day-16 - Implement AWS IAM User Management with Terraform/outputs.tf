output "iam_user_names" {
  description = "IAM users created from users.csv"
  value       = keys(aws_iam_user.users)
}

output "education_group_members" {
  description = "Users assigned to Education group"
  value       = aws_iam_group_membership.education.users
}

output "manager_group_members" {
  description = "Users assigned to Managers group"
  value       = aws_iam_group_membership.managers.users
}

output "engineer_group_members" {
  description = "Users assigned to Engineers group"
  value       = aws_iam_group_membership.engineers.users
}

output "login_passwords" {
  description = "Temporary IAM console passwords. Save securely and do not commit."
  value = {
    for username, profile in aws_iam_user_login_profile.users :
    username => profile.password
  }
  sensitive = true
}