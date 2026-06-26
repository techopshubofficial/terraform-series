variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "techops-demo"
}

variable "project" {
  description = "Project name — used as a prefix in all resource names"
  type        = string
  default     = "techops-hub"
}

# ── VPC inputs (copy these from EP06 terraform output) ───────────────────────

variable "vpc_id" {
  description = "VPC ID from EP06 output"
  type        = string
}

variable "public_subnet_id" {
  description = "One public subnet ID from EP06 output (first one)"
  type        = string
}

# ── EC2 config ────────────────────────────────────────────────────────────────

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for SSH access (must already exist in AWS)"
  type        = string
}
