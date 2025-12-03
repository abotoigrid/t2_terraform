terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-2025-gro"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}