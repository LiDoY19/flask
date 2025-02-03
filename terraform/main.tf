# Terraform Configuration (Terraform Cloud)

terraform {
  required_version = ">= 1.0.0"

  # Configure Terraform Cloud integration
  cloud {
    organization = "lidoy19"
    workspaces {
      name = "flaskapp-1114"
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
}

resource "aws_default_subnet" "public" {
  availability_zone = "us-east-1a"
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.keypair_public_key_path)
}

resource "aws_instance" "flask_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = aws_default_subnet.public.id
  key_name               = aws_key_pair.this.key_name

  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-linux-x86_64 \
      -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    docker-compose up -d


  EOT

  tags = {
    Name = "FlaskAppEC2"
  }
}