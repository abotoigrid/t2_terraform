variable "region" {
  description = "AWS region to deploy the instance"
  type        = string

  validation {
    condition     = length(var.region) >= 7 && can(regex("^([a-z]{2}-[a-z]+-[0-9])$", var.region))
    error_message = "Region must follow AWS region format (e.g., us-east-1)"
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-f]{17}$", var.ami_id))
    error_message = "AMI ID must start with 'ami-' followed by 17 alphanumeric characters"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Instance type must be one of: t2.micro, t3.micro, t3.small"
  }
}

variable "subnet_id" {
  description = "Subnet ID where instance will be deployed"
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]{17}$", var.subnet_id))
    error_message = "Subnet ID must start with 'subnet-' followed by 17 alphanumeric characters"
  }
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) > 0 && alltrue([for sg in var.security_group_ids : can(regex("^sg-[0-9a-f]{17}$", sg))])
    error_message = "Security group IDs must start with 'sg-' followed by 17 alphanumeric characters and list cannot be empty"
  }
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "my-ec2-instance"
}

variable "volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "additional_tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = false
}