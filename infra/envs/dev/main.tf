module "vpc" { source = "../../modules/vpc"; cidr_block = "10.0.0.0/16"; env = "dev" }
module "dynamodb" { source = "../../modules/dynamodb"; env = "dev" }
