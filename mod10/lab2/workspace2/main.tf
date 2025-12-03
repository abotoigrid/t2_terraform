provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "workspace1" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-bucket-2025-gro"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}

output "resource_count" {
  value = length(data.terraform_remote_state.workspace1.outputs[*])
}


resource "aws_s3_bucket" "workspace2_bucket" {
  bucket = "workspace2-test-bucket"
}