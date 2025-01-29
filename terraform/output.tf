output "ec2_public_ip" {
  description = "Public IP of the created EC2 instance"
  value       = aws_instance.flask_ec2.public_ip
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.flask_ec2.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.project_bucket.bucket
}
