run "verify_s3_bucket_configuration" {
  assert {
    condition     = aws_s3_bucket.my_bucket.id != ""
    error_message = "S3 bucket was not created"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.block_public_access.block_public_acls == true
    error_message = "S3 bucket is publicly accessible"
  }

  assert {
    condition     = aws_s3_bucket.my_bucket.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "Encryption at rest is not enabled"
  }
}