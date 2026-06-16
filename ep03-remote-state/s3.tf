# ─────────────────────────────────────────────────────────────────────────────
# S3 bucket — stores Terraform state files for the entire team
# One bucket, multiple projects (each project uses a different key path)
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name

  tags = {
    Name    = var.state_bucket_name
    Purpose = "terraform-remote-state"
  }
}

# State files must never be publicly accessible
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning — every terraform apply writes a new state version
# Accidentally corrupted state? Restore the previous version from S3 console
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt state at rest — state files contain resource IDs, IPs, and other
# sensitive infrastructure details
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
