output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance — open in browser to see Nginx"
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "Ready-to-run SSH command"
  value       = "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${aws_instance.web.public_ip}"
}

output "nginx_url" {
  description = "Open this in a browser after apply"
  value       = "http://${aws_instance.web.public_ip}"
}
