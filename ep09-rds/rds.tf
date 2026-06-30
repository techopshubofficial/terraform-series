# ─────────────────────────────────────────────────────────────────────────────
# Production password pattern:
# 1. Terraform generates a strong random password
# 2. Stores it in AWS Secrets Manager (encrypted)
# 3. RDS uses it directly — password never appears in tfvars or git
# ─────────────────────────────────────────────────────────────────────────────
resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]"
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.project}/rds/master-password"
  description             = "RDS master password — managed by Terraform"
  recovery_window_in_days = 0   # immediate deletion — use 7-30 in production

  tags = { Name = "${var.project}-db-secret" }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db.result
}

# ─────────────────────────────────────────────────────────────────────────────
# DB Subnet Group — tells RDS which private subnets it can use
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name        = "${var.project}-db-subnet-group"
  description = "Private subnets for RDS"
  subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = { Name = "${var.project}-db-subnet-group" }
}

# ─────────────────────────────────────────────────────────────────────────────
# RDS MySQL Instance
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_db_instance" "main" {
  identifier     = "${var.project}-mysql"
  engine         = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result   # generated — never in tfvars

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = var.multi_az
  publicly_accessible = false

  storage_encrypted   = true
  deletion_protection = var.deletion_protection

  skip_final_snapshot = var.skip_final_snapshot

  tags = { Name = "${var.project}-mysql" }
}
