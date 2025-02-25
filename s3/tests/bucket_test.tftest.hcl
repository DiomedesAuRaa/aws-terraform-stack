variables {
  bucket_name = "tactus-au-rath"
}

# Test 1: Check bucket name
run "check_bucket_name" {
  command = plan

  assert {
    condition     = aws_s3_bucket.my_bucket.bucket == var.bucket_name
    error_message = "Bucket name does not match the expected value"
  }
}

# Test 2: Check bucket ACL
run "check_bucket_acl" {
  command = plan

  assert {
    condition     = aws_s3_bucket.my_bucket.acl == "private"
    error_message = "Bucket ACL is not set to private"
  }
}

# Test 3: Check versioning
run "check_versioning" {
  command = plan

  assert {
    condition     = aws_s3_bucket.my_bucket.versioning[0].enabled == true
    error_message = "Versioning is not enabled on the bucket"
  }
}

# Test 4: Check server-side encryption
run "check_server_side_encryption" {
  command = plan

  assert {
    condition     = aws_s3_bucket.my_bucket.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "Server-side encryption is not set to AES256"
  }
}

# Test 5: Check public access block settings
run "check_public_access_block" {
  command = plan

  assert {
    condition     = aws_s3_bucket_public_access_block.block_public_access.block_public_acls == true
    error_message = "Block public ACLs is not set to true"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.block_public_access.block_public_policy == true
    error_message = "Block public policy is not set to true"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.block_public_access.ignore_public_acls == true
    error_message = "Ignore public ACLs is not set to true"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.block_public_access.restrict_public_buckets == true
    error_message = "Restrict public buckets is not set to true"
  }
}