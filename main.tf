terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "web_cluster" {
  source        = "./modules/aws-web-cluster"
  environment   = var.environment
  server_count  = var.server_count
  instance_type = var.instance_type
}

output "live_server_endpoints" {
  value       = module.web_cluster.server_public_ips
  description = "Public HTTP endpoints for the CloudForge cluster"
}