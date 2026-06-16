terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Step 2: Uncomment this AFTER S3 bucket + DynamoDB table are created.
  # Fill in your bucket name, then run: terraform init
  # Terraform will ask to migrate local state → S3. Type yes.
  #
  backend "s3" {
    bucket         = "techops-hub-terraform-state-2026"
    key            = "ep03/terraform.tfstate"
    region         = "us-east-1"
    profile        = "techops-demo"
    dynamodb_table = "techops-hub-prod-tf-locks"
    encrypt        = true
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
      Episode     = "EP03"
    }
  }
}
