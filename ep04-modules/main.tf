terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project   = "techops-hub"
      ManagedBy = "terraform"
      Episode   = "EP04"
    }
  }
}

# ── Same module, called twice — dev + prod ───────────────────────────────────

module "dev_bucket" {
  source = "./modules/s3-bucket"

  bucket_name        = "${var.project}-dev-app-2026"
  environment        = "dev"
  versioning_enabled = false # dev mein versioning off — cost bachao
}

module "prod_bucket" {
  source = "./modules/s3-bucket"

  bucket_name        = "${var.project}-prod-app-2026"
  environment        = "prod"
  versioning_enabled = true # prod mein versioning hamesha on
}

