resource "aws_s3_bucket" "example" {
  bucket = "my-test-bucket-ab"
  lifecycle {
    prevent_destroy = true
  }
}
