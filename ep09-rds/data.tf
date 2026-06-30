# ─────────────────────────────────────────────────────────────────────────────
# Reads EP08 VPC state — fetches vpc_id and private subnet IDs
# RDS will be placed in private subnets (not reachable from internet)
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

# ─────────────────────────────────────────────────────────────────────────────
# Reads EP08 EC2 state — fetches the EC2 security group ID
# RDS will only allow connections from this security group (the jump host)
# ─────────────────────────────────────────────────────────────────────────────
data "terraform_remote_state" "ec2" {
  backend = "s3"

  config = {
    bucket  = "techops-hub-terraform-state-2026"
    key     = "ep08/ec2/terraform.tfstate"
    region  = "us-east-2"
    profile = "techops-demo"
  }
}
