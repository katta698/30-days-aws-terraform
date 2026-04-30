output "vpc_id_used" {
  value = data.aws_vpc.shared.id
}

output "subnet_id_used" {
  value = data.aws_subnet.shared.id
}

output "ami_id_used" {
  value = data.aws_ami.amazon_linux_2.id
}

output "instance_id" {
  value = aws_instance.day13_instance.id
}

output "instance_public_ip" {
  value = aws_instance.day13_instance.public_ip
}