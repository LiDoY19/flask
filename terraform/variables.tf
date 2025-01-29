# Variables

variable "aws_region" {
  type    = string
  default = "us-east-1"
  description = "AWS region to deploy into."
}

variable "s3_bucket_name" {
  type    = string
  default = "my-flask-bucket"
  description = "Name of the S3 bucket."
}

variable "key_name" {
  type    = string
  default = "my-project-key"
  description = "Key pair name to register in AWS."
}

variable "keypair_public_key_path" {
  type        = string
  default     = "./mykey.pub"
  description = "Path to the *public* key file."
}

variable "ami_id" {
  type        = string
  default     = "ami-00000000000000000"
  description = "AMI ID for the EC2 instance (e.g., Amazon Linux 2)."
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type for the EC2."
}

variable "security_group_id" {
  type        = string
  default     = "sg-00000000000000000"
  description = "Security group ID for EC2."
}

variable "subnet_id" {
  type        = string
  default     = "subnet-00000000000000000"
  description = "Subnet ID for EC2."
}
