output "public_ip" {
  value = aws_instance.web.public_ip
}

output "nginx_url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  value = "ssh -i  ~/Downloads/${var.key_pair_name}.pem ec2-user@${aws_instance.web.public_ip}"
}

# ── These values came from the VPC state file — no manual input ──────────────
# EP07 mein ye dono variables.tf mein define karne padte the
# EP08 mein terraform_remote_state ne automatically fetch kar liya

output "vpc_id_from_state" {
  description = "VPC ID fetched automatically from vpc/ state file"
  value       = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "public_subnet_id_from_state" {
  description = "Public subnet ID fetched automatically from vpc/ state file"
  value       = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
}
