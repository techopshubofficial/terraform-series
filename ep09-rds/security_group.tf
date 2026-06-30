# ─────────────────────────────────────────────────────────────────────────────
# RDS Security Group
# Only allows PostgreSQL traffic (port 5432) from the EC2 jump host SG.
# No direct internet access — production best practice.
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_security_group" "rds" {
  name        = "${var.project}-rds-sg"
  description = "Allow MySQL only from EC2 jump host"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description     = "MySQL from EC2 jump host only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.ec2.outputs.security_group_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-rds-sg" }
}
