terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "techops-demo"
}

resource "aws_s3_bucket" "demo" {
  bucket = "techops-hub-ep011-demo-2026"

  tags = {
    Name        = "TechOps Hub EP01"
    Environment = "learning"
  }
}
