output "load_balancer_dns_name" {
  value = aws_lb.blockchain_client_lb.dns_name
}

output "load_balancer_security_group_id" {
  value = aws_security_group.lb_sg.id
}
