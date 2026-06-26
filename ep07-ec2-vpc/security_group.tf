# ─────────────────────────────────────────────────────────────────────────────
# Security Group — acts as a virtual firewall for the EC2 instance
# Inbound: allow SSH (22) and HTTP (80)
# Outbound: allow everything (so the server can download packages)
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_security_group" "web" {
  name        = "${var.project}-web-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = var.vpc_id

  # SSH — for terminal access to the server
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.215.251.119/32"]
  }

  # HTTP — so we can open the Nginx page in a browser
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound — allow all (needed for package installs, AWS API calls)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-web-sg"
  }
}
