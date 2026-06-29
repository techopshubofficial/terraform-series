resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  # subnet_id is coming from the VPC state file — not from variables
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "<h1>EP08: terraform_remote_state demo — TechOps Hub</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = { Name = "${var.project}-web-server" }
}
