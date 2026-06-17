output "dev_bucket_name" {
  description = "Dev S3 bucket name"
  value       = module.dev_bucket.bucket_name
}

output "dev_bucket_arn" {
  description = "Dev S3 bucket ARN"
  value       = module.dev_bucket.bucket_arn
}

output "prod_bucket_name" {
  description = "Prod S3 bucket name"
  value       = module.prod_bucket.bucket_name
}

output "prod_bucket_arn" {
  description = "Prod S3 bucket ARN"
  value       = module.prod_bucket.bucket_arn
}
