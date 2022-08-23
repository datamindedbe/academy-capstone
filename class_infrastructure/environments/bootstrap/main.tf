resource "aws_s3_bucket" "capstone-bucket" {
  bucket = "dataminded-academy-capstone-resources"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = "dataminded-academy-capstone-resources"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_public_access_block" "capstone-bucket-block" {
  bucket = aws_s3_bucket.capstone-bucket.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_secretsmanager_secret" "snowflake_admin" {
  name = "snowflake/terraform/password"
}