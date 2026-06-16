output "state_bucket_name" {
  description = "S3 bucket name — use as 'bucket' in backend config"
  value       = aws_s3_bucket.tf_state.id
}

output "state_bucket_arn" {
  description = "ARN of the state bucket"
  value       = aws_s3_bucket.tf_state.arn
}

output "lock_table_name" {
  description = "DynamoDB table name — use as 'dynamodb_table' in backend config"
  value       = aws_dynamodb_table.tf_state_lock.name
}

output "backend_config" {
  description = "Copy this into the terraform block of any project using this backend"
  value       = <<-EOT

    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.tf_state.id}"
        key            = "<project-name>/terraform.tfstate"
        region         = "${var.aws_region}"
        profile        = "${var.aws_profile}"
        dynamodb_table = "${aws_dynamodb_table.tf_state_lock.name}"
        encrypt        = true
      }
    }

  EOT
}
