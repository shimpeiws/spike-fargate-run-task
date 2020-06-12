provider "aws" {
  profile = "default"
  version = "~> 2.44"
}

terraform {
  required_version = "~> 0.12.0"
  # ~>: pessimistic constraint operator.
  # Example: for ~> 0.9, this means >= 0.9, < 1.0.
  # Example: for ~> 0.8.4, this means >= 0.8.4, < 0.9

  backend "s3" {
    bucket = "spike-fargate-run-task"
    key    = "main/terraform.tfstate"
  }
}

module "vpc" {
  source   = "./modules/vpc"
}

module "iam_role" {
  source   = "./modules/iam_role"
  identifier = "ecs-tasks.amazonaws.com"
}

module "task_definition" {
  source   = "./modules/task_definition"
  image_uri = "607754652120.dkr.ecr.ap-northeast-1.amazonaws.com/node-app:latest"
  ecs_task_execution_role_iam_role_arn = module.iam_role.ecs_task_execution_role_iam_role_arn
}
