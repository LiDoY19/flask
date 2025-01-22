###############################################################################
# 1. Terraform Configuration
###############################################################################
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

###############################################################################
# 2. Security Group
#    - Allows inbound: SSH (22), port 5001 for Flask, optional 3307 for MySQL
#    - Allows all outbound
###############################################################################
resource "aws_security_group" "gif_app_sg" {
  name        = "tf-gif-app-sg"
  description = "Security group for Flask+MySQL Docker setup"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flask external access on host port 5001
  ingress {
    description = "Flask"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL external access on host port 3307 (NOT recommended for production)
  # Remove if you don't need external DB access
  ingress {
    description = "MySQL"
    from_port   = 3307
    to_port     = 3307
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # If you also want port 80 or 443 open, uncomment below:
  # ingress {
  #   description = "HTTP"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description = "HTTPS"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###############################################################################
# 3. EC2 Instance - Docker Host
###############################################################################
resource "aws_instance" "gif_app_instance" {
  ami           = "ami-01816d07b1128cd2d" # Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"

  # Optional: Set your own key pair for SSH if you want to connect
    key_name = "Liron-test"

  vpc_security_group_ids = [aws_security_group.gif_app_sg.id]

  # Install Docker & docker-compose, clone your repo, run docker-compose
  user_data = <<-EOF
    #!/bin/bash
    set -xe

    yum update -y
    yum install -y docker git

    # Install python3-pip to get docker-compose via pip
    yum install -y python3-pip
    pip3 install docker-compose
    usermod -a -G docker ec2-user

    # Enable & start Docker
    systemctl enable docker
    systemctl start docker

    # Clone your GitHub repo containing Dockerfile & docker-compose.yml
    cd /home/ec2-user
    git clone https://github.com/LiDoY19/flask.git
    cd flask

    # (Optional) If you have a specific branch: git checkout main

    # Bring up your containers in detached mode
    /usr/local/bin/docker-compose up -d
  EOF

  tags = {
    Name = "gif-app-docker-host"
  }
}

###############################################################################
# 4. Local File - Store Public IP
###############################################################################
resource "local_file" "public_ip_txt" {
  content  = aws_instance.gif_app_instance.public_ip
  filename = "${path.module}/public_ip.txt"
}

###############################################################################
# 5. Outputs
###############################################################################
output "public_ip" {
  description = "Public IP of the EC2 instance hosting the GIF Docker app"
  value       = aws_instance.gif_app_instance.public_ip
}
