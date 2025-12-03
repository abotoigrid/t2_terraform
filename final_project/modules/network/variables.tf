variable "project_id" {}
variable "region" {}
variable "allowed_ips" {
  default = ["0.0.0.0/0"]
}
variable "instance_group" {
  description = "Instance group for the backend service"
}