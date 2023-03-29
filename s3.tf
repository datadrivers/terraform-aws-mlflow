resource "aws_s3_bucket" "default" {
  count         = local.create_dedicated_bucket ? 1 : 0
  bucket_prefix = var.unique_name
  acl           = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "history"
    enabled = true
    transition {
      days          = 60
      storage_class = "INTELLIGENT_TIERING"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.artifact_bucket_encryption_key_arn
        sse_algorithm     = var.artifact_bucket_encryption_algorithm
      }
    }
  }

  tags = merge(
    {
      Name = "${var.unique_name}-default-artifact-root"
    },
    local.tags
  )
}
