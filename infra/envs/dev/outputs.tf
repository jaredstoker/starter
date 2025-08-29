output "vpc_id" { value = module.vpc.vpc_id }
output "subnet_ids" { value = module.vpc.subnet_ids }
output "dynamodb_table" { value = module.dynamodb.table_name }
output "ecs_cluster" { value = module.ecs_service.cluster_id }
output "ecs_service" { value = module.ecs_service.service_id }
