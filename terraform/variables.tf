# variables.tf
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Name of the AWS key pair to create/use"
}

variable "public_key_path" {
  type        = string
  description = "Path to the local public SSH key"
}

variable "ami_id" {
  type        = string
  default     = ami-01816d07b1128cd2d
  description = "ami-01816d07b1128cd2d"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for instance"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for instance"
}

variable "ec2_tag_name" {
  type        = string
  default     = "flaskapp-ec2"
}
