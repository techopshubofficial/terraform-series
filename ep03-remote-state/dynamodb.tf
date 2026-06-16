# ─────────────────────────────────────────────────────────────────────────────
# DynamoDB table — Terraform state locking
#
# When two engineers run terraform apply at the same time:
#   Engineer A → gets the lock (LockID entry written here)
#   Engineer B → sees the lock → waits / errors out
#   Engineer A → apply done  → lock released (LockID entry deleted)
#
# hash_key MUST be exactly "LockID" — hard requirement of Terraform S3 backend
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_dynamodb_table" "tf_state_lock" {
  name         = "${var.project}-${var.environment}-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name    = "${var.project}-${var.environment}-tf-locks"
    Purpose = "terraform-state-locking"
  }
}
