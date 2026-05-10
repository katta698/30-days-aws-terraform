output "application_url" {
  value = "http://${module.ec2.public_ip}"
}

output "web_server_public_ip" {
  value = module.ec2.public_ip
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}