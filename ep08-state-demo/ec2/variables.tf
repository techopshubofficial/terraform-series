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
  description = "Project name"
  type        = string
  default     = "techops-hub"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "EC2 Key Pair name (must exist in AWS)"
  type        = string
}

# Notice: no vpc_id or subnet_id here.
# Those come automatically from the VPC state file.
