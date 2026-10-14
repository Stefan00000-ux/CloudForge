variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "Production-v2"
}

variable "server_count" {
  description = "Number of web servers to deploy"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}