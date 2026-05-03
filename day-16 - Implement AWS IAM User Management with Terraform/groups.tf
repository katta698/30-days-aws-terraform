resource "aws_iam_group" "education" {
  name = "Education"
  path = "/groups/"
}

resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

resource "aws_iam_group" "engineers" {
  name = "Engineers"
  path = "/groups/"
}

resource "aws_iam_group_membership" "education" {
  name  = "education-group-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.users : user.name
    if user.tags.Department == "Education"
  ]
}

resource "aws_iam_group_membership" "managers" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name

  users = [
    for user in aws_iam_user.users : user.name
    if can(regex("Manager|CEO|Vice President|Director|CFO", user.tags.JobTitle))
  ]
}

resource "aws_iam_group_membership" "engineers" {
  name  = "engineers-group-membership"
  group = aws_iam_group.engineers.name

  users = [
    for user in aws_iam_user.users : user.name
    if user.tags.Department == "Engineering"
  ]
}