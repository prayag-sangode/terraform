output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
  description = "VPC CIDR block"
}

output "public_subnet_cidr_blocks" {
  value = [
    aws_subnet.public[0].cidr_block,
    aws_subnet.public[1].cidr_block
  ]
  description = "Public Subnet CIDR blocks"
}

output "private_subnet_cidr_blocks" {
  value = [
    aws_subnet.private[0].cidr_block,
    aws_subnet.private[1].cidr_block
  ]
  description = "Private Subnet CIDR blocks"
}

output "public_subnet_ip_range" {
  value = [
    cidrsubnet(aws_subnet.public[0].cidr_block, 8, 0),
    cidrsubnet(aws_subnet.public[1].cidr_block, 8, 0)
  ]
  description = "Public Subnet IP ranges"
}

output "private_subnet_ip_range" {
  value = [
    cidrsubnet(aws_subnet.private[0].cidr_block, 8, 0),
    cidrsubnet(aws_subnet.private[1].cidr_block, 8, 0)
  ]
  description = "Private Subnet IP ranges"
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "Bastion Host Public IP"
}

output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
  description = "Bastion Host Private IP"
}

output "db_instance_private_ip" {
  value = aws_instance.db_instance.private_ip
  description = "DB Instance Private IP"
}
