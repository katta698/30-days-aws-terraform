output "shared_vpc_id" {
  value = aws_vpc.shared_vpc.id
}

output "shared_subnet_id" {
  value = aws_subnet.shared_subnet.id
}