terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Optionally configure backend here or in backend.tf
  # backend "s3" {
  #   bucket = "my-terraform-state-bucket"
  #   key    = "path/to/my-flask-app.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.region
  # If you rely on Jenkins-provided AWS credentials, 
  # you can set them via environment variables, or an AWS profile, etc.
}

# Create a key pair if you don't already have one
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Create the EC2 instance
resource "aws_instance" "flask_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.this.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Example for Amazon Linux 2
    yum update -y
    echo "Installing docker..."
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    echo "Docker Compose v2 is now available as 'docker compose'..."
  EOF

  tags = {
    Name = var.ec2_tag_name
  }
}
