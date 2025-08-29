terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
}

variable "service_name" { type = string }
variable "container_image" { type = string }
variable "cpu" { type = number default = 256 }
variable "memory" { type = number default = 512 }
variable "desired_count" { type = number default = 1 }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "env_vars" { type = map(string) default = {} }
variable "assign_public_ip" { type = bool default = false }

resource "aws_ecs_cluster" "this" {
  name = "${var.service_name}-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn
  container_definitions = jsonencode([{
    name      = var.service_name
    image     = var.container_image
    essential = true
    environment = [for k,v in var.env_vars : { name = k, value = v }]
    portMappings = [{
      containerPort = 8080
      protocol = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }
}

resource "aws_iam_role" "ecs_task_exec" {
  name = "${var.service_name}-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

output "cluster_id" { value = aws_ecs_cluster.this.id }
output "service_id" { value = aws_ecs_service.this.id }
