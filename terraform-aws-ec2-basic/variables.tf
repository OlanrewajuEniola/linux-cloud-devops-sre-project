variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Name used to tag and identify project resources"
  type        = string
  default     = "terraform-web"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}