provider "aws" {
  region = "us-east-1" 
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-2025-gro"  
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

