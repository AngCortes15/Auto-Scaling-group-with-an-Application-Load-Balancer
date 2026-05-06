variable "aws_region" {
  description = "AWS region for the resources"
  type = string
  default = "us-east-1"
}

variable "project_name" {
  description = "Project name for tagging"
  type = string
  default = "cafe"
}