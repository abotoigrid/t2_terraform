provider "aws" {
  region = "us-east-1" 
}

# Bucket 1
resource "aws_s3_bucket" "bucket1" {
  bucket = "my-bucket1-2025-lab3"
}

# resource "aws_s3_bucket" "bucket2" {
#   bucket = "my-bucket2-2025-lab3"
#   depends_on = [aws_s3_bucket.bucket1]
# }

resource "aws_s3_bucket" "bucket3" {
  bucket = "my-bucket3-2025-lab3"
  depends_on = [
    aws_s3_bucket.bucket1,
    # aws_s3_bucket.bucket2
  ]
}

output "bucket_names" {
  value = [
    aws_s3_bucket.bucket1.id,
    # aws_s3_bucket.bucket2.id,
    aws_s3_bucket.bucket3.id
  ]
}