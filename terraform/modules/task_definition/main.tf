data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy
}

resource "aws_ecs_task_definition" "node-app" {
  family                   = "node-app"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions =<<DEFINITION
  [
    {
      "name": "node-app",
      "image": "${var.image_uri}",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "node-app",
          "awslogs-group": "/fargate/run-task"
        }
      }
    }
  ]
  DEFINITION

  task_role_arn =  var.ecs_task_execution_role_iam_role_arn
  execution_role_arn = var.ecs_task_execution_role_iam_role_arn
}

resource "aws_cloudwatch_log_group" "fargate_log_group" {
  name = "/fargate/run-task"
  retention_in_days = 180
}

