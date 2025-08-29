terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
  backend "s3" {
    bucket = "revops-tfstate-dev"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" { region = "us-east-1" }

module "vpc" {
  source     = "../../modules/vpc"
  cidr_block = "10.0.0.0/16"
  env        = "dev"
}

module "dynamodb" {
  source     = "../../modules/dynamodb"
  env        = "dev"
  table_name = "entities"
}

module "ecs_service" {
  source            = "../../modules/ecs-fargate"
  service_name      = "routing-service"
  container_image   = "public.ecr.aws/amazonlinux/amazonlinux:latest"
  subnet_ids        = module.vpc.subnet_ids
  security_group_ids = [aws_security_group.ecs_sg.id]
  env_vars = {
    "ENV"        = "dev"
    "TABLE_NAME" = module.dynamodb.table_name
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg-dev"
  description = "Allow ECS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
