resource "aws_s3_bucket" "unrestricted" {
  bucket = "examplebuckettftest"
  #zpc-skip-policy: ZS-AWS-00034:testing
  acl    = "public-read-write"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
    }
}

resource "aws_s3_bucket" "km_blob_storage" {
  bucket = "km-blob-storage-${var.environment}"
  acl    = "private"
  tags = merge(var.default_tags, {
    name = "km_blob_storage_${var.environment}"
  })
}

resource "aws_kms_key" "km_db_kms_key" {
  description             = "KMS Key for DB instance ${var.environment}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = merge(var.default_tags, {
    Name = "km_db_kms_key_${var.environment}"
  })
}

resource "aws_db_subnet_group" "km_rds_subnet_grp" {
  name       = "km_rds_subnet_grp_${var.environment}"
  subnet_ids = var.private_subnet

  tags = merge(var.default_tags, {
    Name = "km_rds_subnet_grp_${var.environment}"
  })
}
