# ─────────────────────────────────────────────────────────────────────────────
# S3 bucket — name automatically includes workspace name
# Same code, alag workspace = alag bucket
#
# dev   workspace → techops-hub-dev-app-2026
# staging         → techops-hub-staging-app-2026
# prod            → techops-hub-prod-app-2026
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_s3_bucket" "app" {
  bucket = "${var.project}-${terraform.workspace}-app-2026"

  tags = {
    Name = "${var.project}-${terraform.workspace}-app-2026"
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id

  versioning_configuration {
    # dev mein off (cost bachao), staging+prod mein on
    status = var.env_config[terraform.workspace].versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
