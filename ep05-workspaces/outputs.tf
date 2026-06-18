output "workspace" {
  description = "Current active workspace"
  value       = terraform.workspace
}

output "bucket_name" {
  description = "S3 bucket created in this workspace"
  value       = aws_s3_bucket.app.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.app.arn
}

output "versioning_status" {
  description = "Versioning enabled for this environment?"
  value       = var.env_config[terraform.workspace].versioning_enabled ? "Enabled" : "Disabled"
}
