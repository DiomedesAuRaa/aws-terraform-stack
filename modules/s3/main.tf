resource "aws_s3_bucket" "bucket" {
  bucket = "my-terraform-bucket"
  acl    = "private"
}
