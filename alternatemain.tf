/*
# ============================================================
# 1. Terraform and AWS Provider
# ============================================================

terraform {
  required_version = ">= 1.5.0"

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

# ============================================================
# 2. Create a VPC
# ============================================================

resource "aws_vpc" "nginx_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "Terraform-Nginx-VPC"
    ManagedBy = "Terraform"
  }
}

# ============================================================
# 3. Create a Public Subnet
# ============================================================

resource "aws_subnet" "nginx_subnet" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name      = "Terraform-Nginx-Public-Subnet"
    ManagedBy = "Terraform"
  }
}

# ============================================================
# 4. Create an Internet Gateway
# ============================================================

resource "aws_internet_gateway" "nginx_igw" {
  vpc_id = aws_vpc.nginx_vpc.id

  tags = {
    Name      = "Terraform-Nginx-Internet-Gateway"
    ManagedBy = "Terraform"
  }
}

# ============================================================
# 5. Create a Route Table for Internet Access
# ============================================================

resource "aws_route_table" "nginx_route_table" {
  vpc_id = aws_vpc.nginx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx_igw.id
  }

  tags = {
    Name      = "Terraform-Nginx-Public-Route-Table"
    ManagedBy = "Terraform"
  }
}

# Associate the route table with the public subnet.
resource "aws_route_table_association" "nginx_route_association" {
  subnet_id      = aws_subnet.nginx_subnet.id
  route_table_id = aws_route_table.nginx_route_table.id
}

# ============================================================
# 6. Create a Security Group
# ============================================================

resource "aws_security_group" "nginx_sg" {
  name        = "terraform-nginx-sg"
  description = "Allow HTTP and restricted SSH access"
  vpc_id      = aws_vpc.nginx_vpc.id

  # Allow HTTP traffic from any IPv4 address.
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH only from your configured public IP.
  ingress {
    description = "SSH - restricted to my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Allow outbound internet traffic for package installation.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "Terraform-Nginx-Security-Group"
    ManagedBy = "Terraform"
  }
}

# ============================================================
# 7. Find the Ubuntu 20.04 LTS AMI
# ============================================================

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# ============================================================
# 8. Create the EC2 Instance and Install Nginx
# ============================================================

resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.nginx_subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  # Install Nginx and configure the custom webpage at first boot.
  user_data = <<-EOF
    #!/bin/bash
    set -e

    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y nginx

    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <title>Terraform Nginx Server</title>
    </head>
    <body>
      <h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>
    </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl restart nginx
  EOF

  user_data_replace_on_change = true

  tags = {
    Name        = "Terraform-Nginx-Ubuntu"
    Environment = "Assignment"
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_route_table_association.nginx_route_association
  ]
}
