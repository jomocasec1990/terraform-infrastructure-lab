variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC CIDR must be a valid IPv4 or IPv6 CIDR."
  }
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "The subnet CIDR must be a valid IPv4 or IPv6 CIDR."
  }
}