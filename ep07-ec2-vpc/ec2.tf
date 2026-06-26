# ─────────────────────────────────────────────────────────────────────────────
# EC2 Instance — launched inside the public subnet from EP06
# user_data runs on first boot: installs and starts Nginx automatically
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_pair_name

  # Runs on first boot — installs Nginx and serves a simple page
  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "<h1>EP07: EC2 inside VPC — Terraform by TechOps Hub</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "${var.project}-web-server"
  }
}
