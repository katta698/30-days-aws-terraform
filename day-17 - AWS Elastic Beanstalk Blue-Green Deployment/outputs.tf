output "blue_url" {
  value = aws_elastic_beanstalk_environment.blue.endpoint_url
}

output "green_url" {
  value = aws_elastic_beanstalk_environment.green.endpoint_url
}