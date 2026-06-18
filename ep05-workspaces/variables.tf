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
  description = "Project name prefix"
  type        = string
  default     = "techops-hub"
}

# Per-environment config — workspace name is the key
# terraform.workspace returns "dev", "staging", or "prod"
variable "env_config" {
  description = "Per-environment settings"
  type = map(object({
    versioning_enabled = bool
    instance_class     = string   # placeholder — shows teams store env-specific values here
  }))

  default = {
    dev = {
      versioning_enabled = false
      instance_class     = "small"
    }
    staging = {
      versioning_enabled = true
      instance_class     = "medium"
    }
    prod = {
      versioning_enabled = true
      instance_class     = "large"
    }
  }
}
