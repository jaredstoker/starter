provider "aws" { region = var.aws_region }
variable "aws_region" { type = string, default = "us-west-2" }
