output "db_endpoint" {
  description = "RDS connection endpoint (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "db_host" {
  description = "RDS hostname only"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Master username"
  value       = aws_db_instance.main.username
}

# How to connect via EC2 jump host:
output "connect_via_jump_host" {
  description = "SSH tunnel command — run this on your local machine"
  value       = "ssh -L 3306:${aws_db_instance.main.address}:3306 -i ~/Downloads/testing.pem ec2-user@<ec2-public-ip>"
}

output "secret_manager_arn" {
  description = "ARN of the Secrets Manager secret storing the DB password"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "get_password_command" {
  description = "AWS CLI command to retrieve the DB password from Secrets Manager"
  value       = "aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.db_password.id} --profile ${var.aws_profile} --region ${var.aws_region} --query SecretString --output text"
}
