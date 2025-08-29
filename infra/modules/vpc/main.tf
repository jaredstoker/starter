terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
}
variable "cidr_block" { type = string }
variable "env" { type = string }
variable "az_count" { type = number default = 2 }

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = { Name = "revops-vpc-${var.env}" }
}

resource "aws_subnet" "private" {
  count             = var.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "revops-private-${var.env}-${count.index}" }
}

data "aws_availability_zones" "available" {}
