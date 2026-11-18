provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Terraform-Lab01"
      Environment = "Lab"
      ManagedBy   = "Terraform"
    }
  }
}