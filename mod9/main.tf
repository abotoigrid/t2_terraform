terraform {
  required_version = ">= 1.0"
}

module "my_ec2" {
  source             = "./ec2-module"
  region             = "us-east-1"
  ami_id             = "ami-00a929b66ed6e0de6"
  instance_type      = "t3.micro"
  subnet_id          = "subnet-017cfb4855438bdec"
  security_group_ids = ["sg-054cbec17419c7ac2"]
  instance_name      = "my-test-instance"
}