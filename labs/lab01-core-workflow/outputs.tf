output "vpc_id" {
  description = "ID of the VPC created by Terraform"
  value       = aws_vpc.lab.id
}

output "subnet_id" {
  description = "ID of the subnet created by Terraform"
  value       = aws_subnet.lab.id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  value       = aws_vpc.lab.cidr_block
}