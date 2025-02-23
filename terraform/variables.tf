variable "aws_region" {
  type    = string
  default = "us-east-1"
  description = "AWS region to deploy into."
}

variable "key_name" {
  type    = string
  default = "my-project-key"
  description = "Key pair name to register in AWS."
}

variable "keypair_public_key_path" {
  type        = string
  default     = "/Users/lironmizrahi/Documents/devopscourse/terraform_keys/my_key.pub.pub"
  description = "Path to the *public* key file."
}

variable "ami_id" {
  type        = string
  default     = "ami-01816d07b1128cd2d"
  description = "AMI ID for the EC2 instance (e.g., Amazon Linux 2)."
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type for the EC2."
}

variable "security_group_id" {
  type        = string
  default     = "sg-0814e623c096c1220"
  description = "Security group ID for EC2."
}

variable "gcp_credentials_file" {
  description = "Path to GCP credentials file"
  type        = string
}

variable "gcp_project_id" {
  type    = string
  default = "polar-ray-449912-k6"  
}
