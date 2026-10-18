# AWS region in which to deploy resources.
variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "ap-south-1"
}

# EC2 instance type required.
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# Replace this value with your public IP address followed by /32.
variable "ssh_allowed_cidr" {
  description = "CIDR range allowed to access SSH"
  type        = string
  default     = "223.185.132.206/32"
}


