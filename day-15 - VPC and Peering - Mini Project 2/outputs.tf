output "primary_vpc_id" {
  description = "Primary VPC ID"
  value       = aws_vpc.primary.id
}

output "secondary_vpc_id" {
  description = "Secondary VPC ID"
  value       = aws_vpc.secondary.id
}

output "vpc_peering_connection_id" {
  description = "VPC peering connection ID"
  value       = aws_vpc_peering_connection.peer.id
}

output "primary_instance_public_ip" {
  description = "Primary EC2 public IP"
  value       = aws_instance.primary.public_ip
}

output "primary_instance_private_ip" {
  description = "Primary EC2 private IP"
  value       = aws_instance.primary.private_ip
}

output "secondary_instance_public_ip" {
  description = "Secondary EC2 public IP"
  value       = aws_instance.secondary.public_ip
}

output "secondary_instance_private_ip" {
  description = "Secondary EC2 private IP"
  value       = aws_instance.secondary.private_ip
}

output "test_from_primary" {
  description = "Commands to test from primary EC2"
  value       = <<EOT
ssh -i vpc-peering-demo.pem ec2-user@${aws_instance.primary.public_ip}

ping ${aws_instance.secondary.private_ip}
curl http://${aws_instance.secondary.private_ip}
EOT
}

output "test_from_secondary" {
  description = "Commands to test from secondary EC2"
  value       = <<EOT
ssh -i vpc-peering-demo.pem ec2-user@${aws_instance.secondary.public_ip}

ping ${aws_instance.primary.private_ip}
curl http://${aws_instance.primary.private_ip}
EOT
}