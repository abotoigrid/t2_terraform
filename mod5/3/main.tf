provider "aws" {
  region = "us-east-1"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ec2_enabled" {
  description = "Whether to create the EC2 instance"
  type        = bool
  default     = true
}

variable "predefined_tags" {
  description = "Predefined tags for the EC2 instance"
  type        = map(string)
  default = {
    "Environment" = "Production"
    "Project"     = "MyProject"
    "Owner"       = "TeamA"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "main-subnet"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_sg"
  }
}

resource "aws_instance" "this" {
  count = var.ec2_enabled ? 1 : 0

  ami                    = "ami-0c55b159cbfafe1f0"  
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  depends_on = [aws_subnet.main]

  lifecycle {
    ignore_changes = [tags]
  }

  tags = var.predefined_tags
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = var.ec2_enabled ? aws_instance.this[0].id : null
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = var.ec2_enabled ? aws_instance.this[0].public_ip : null
}

#terraform apply -var 'predefined_tags={"Environment"="Dev","Project"="Test","Owner"="TeamB"}'


#terraform apply -var 'ec2_enabled=false'