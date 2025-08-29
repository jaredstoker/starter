terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
}
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = { Name = "revops-vpc-${var.env}" }
}
