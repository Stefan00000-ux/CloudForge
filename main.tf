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

resource "aws_vpc" "cloudforge_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "CloudForge-VPC-${var.environment}"
  }
}

resource "aws_subnet" "cloudforge_subnet" {
  vpc_id                  = aws_vpc.cloudforge_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "CloudForge-Subnet-${var.environment}"
  }
}

resource "aws_internet_gateway" "cloudforge_gw" {
  vpc_id = aws_vpc.cloudforge_vpc.id
  tags = {
    Name = "CloudForge-IGW-${var.environment}"
  }
}

resource "aws_route_table" "cloudforge_rt" {
  vpc_id = aws_vpc.cloudforge_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudforge_gw.id
  }

  tags = {
    Name = "CloudForge-RT-${var.environment}"
  }
}

resource "aws_route_table_association" "cloudforge_rta" {
  subnet_id      = aws_subnet.cloudforge_subnet.id
  route_table_id = aws_route_table.cloudforge_rt.id
}

resource "aws_security_group" "cloudforge_sg" {
  name        = "cloudforge-sg-${var.environment}"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.cloudforge_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

resource "aws_instance" "cloudforge_server" {
  count                  = var.server_count
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cloudforge_subnet.id
  vpc_security_group_ids = [aws_security_group.cloudforge_sg.id]

  user_data = file("userdata.sh")

  tags = {
    Name = "CloudForge-Server-${count.index + 1}-${var.environment}"
  }
}

output "server_public_ips" {
  value       = [for instance in aws_instance.cloudforge_server : "http://${instance.public_ip}"]
  description = "Public IPs of all provisioned web servers"
}