output "load_balancer_dns" {
  value = aws_lb.alb.dns_name
}

output "nat_gateway_1_ip" {
  value = aws_eip.nat_1.public_ip
}

output "nat_gateway_2_ip" {
  value = aws_eip.nat_2.public_ip
}