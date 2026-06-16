variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "techops-demo"
}

variable "project" {
  description = "Project name used for naming and tagging"
  type        = string
  default     = "techops-hub"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform remote state"
  type        = string
}
