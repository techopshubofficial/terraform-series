# ─────────────────────────────────────────────────────────────────────────────
# Fetches the latest Amazon Linux 2023 AMI ID automatically
# No need to hardcode AMI IDs (they change per region and over time)
# ─────────────────────────────────────────────────────────────────────────────
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
