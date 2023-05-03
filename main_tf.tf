provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_access}"
}

resource "aws_ecs_cluster" "demo-ecs-cluster" {
  name = "ecs-cluster-for-demo"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_ecs_service" "demo-ecs-service-two" {
  name            = "demo-app"
  cluster         = aws_ecs_cluster.demo-ecs-cluster.id
  task_definition = aws_ecs_task_definition.demo-ecs-task-definition.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["${var.subnet}"]
    assign_public_ip = true
  }
  desired_count = 1
}

resource "aws_ecs_task_definition" "demo-ecs-task-definition" {
  family                   = "ecs-task-definition-demo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = 1028
  cpu                      = 1028
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = <<EOF
[
  {
    "name": "demo-container",
    "image": "043392829332.dkr.ecr.ap-south-1.amazonaws.com/my-ecr-repo:pdf", 
    "memory": 512,
    "cpu": 512,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}