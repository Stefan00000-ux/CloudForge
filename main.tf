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

# 1. Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "cloudforge_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "CloudForge-VPC"
  }
}

# 2. Create a Public Subnet
resource "aws_subnet" "cloudforge_subnet" {
  vpc_id                  = aws_vpc.cloudforge_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "CloudForge-Public-Subnet"
  }
}

# 3. Create an Internet Gateway (To allow web access)
resource "aws_internet_gateway" "cloudforge_gw" {
  vpc_id = aws_vpc.cloudforge_vpc.id
  tags = {
    Name = "CloudForge-IGW"
  }
}

# 4. Create a Route Table
resource "aws_route_table" "cloudforge_rt" {
  vpc_id = aws_vpc.cloudforge_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudforge_gw.id
  }

  tags = {
    Name = "CloudForge-RouteTable"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "cloudforge_rta" {
  subnet_id      = aws_subnet.cloudforge_subnet.id
  route_table_id = aws_route_table.cloudforge_rt.id
}

# 5. Security Group (Firewall allowing HTTP on port 80 and SSH on port 22)
resource "aws_security_group" "cloudforge_sg" {
  name        = "cloudforge-web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.cloudforge_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    ="-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CloudForge-SG"
  }
}

# 6. EC2 Server Instance
resource "aws_instance" "cloudforge_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS in us-east-1
  instance_type = var.instance_type
  subnet_id     = aws_subnet.cloudforge_subnet.id
  vpc_security_group_ids = [aws_security_group.cloudforge_sg.id]

  user_data = file("userdata.sh")

  tags = {
    Name = "CloudForge-WebServer"
  }
}

# Output the Live Website URL
output "web_server_ip" {
  value       = "http://${aws_instance.cloudforge_server.public_ip}"
  description = "Public URL of the newly created web server"
}