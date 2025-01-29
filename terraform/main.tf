
# Terraform Configuration (Terraform Cloud)

terraform {
  required_version = ">= 1.0.0"

  # Configure Terraform Cloud integration
  cloud {
    organization = "YOUR_TERRAFORM_CLOUD_ORG"
    workspaces {
      name = "YOUR_TERRAFORM_WORKSPACE"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# AWS Provider

provider "aws" {
  region = var.aws_region
  # Credentials typically come from:
  # 1) Terraform Cloud variable sets
  # 2) Environment variables
  # 3) A workspace-specific config
}


# S3 Bucket

resource "aws_s3_bucket" "project_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name = var.s3_bucket_name
  }
}


# Key Pair (Public Key)

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.keypair_public_key_path)
}


# EC2 Instance

resource "aws_instance" "flask_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.this.key_name

  # User data to install Docker & Docker Compose
  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    # Install Docker Compose v2 (CLI plugin)
    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-linux-x86_64 \
      -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
  EOT

  tags = {
    Name = "FlaskAppEC2"
  }
}
