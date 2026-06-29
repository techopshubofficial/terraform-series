terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # State stored in S3 — any team can now read this state file
  backend "s3" {
    bucket  = "techops-hub-terraform-state-2026"
    key     = "ep08/vpc/terraform.tfstate"
    region  = "us-east-2"
    profile = "techops-demo"
    encrypt = true
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project   = var.project
      ManagedBy = "terraform"
      Episode   = "EP08"
    }
  }
}
