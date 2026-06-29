# ─────────────────────────────────────────────────────────────────────────────
# Reads the VPC state file stored in S3.
# vpc_id and subnet_ids are fetched from here — no manual input needed.
# This is how production teams share infrastructure outputs.
# ─────────────────────────────────────────────────────────────────────────────
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "techops-hub-terraform-state-2026"
    key     = "ep08/vpc/terraform.tfstate"
    region  = "us-east-2"
    profile = "techops-demo"
  }
}

# Fetches the latest Amazon Linux 2023 AMI automatically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
