variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "server_count" {
  description = "Number of web servers to deploy"
  type        = number
  default     = 2
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "Production-v2"
}