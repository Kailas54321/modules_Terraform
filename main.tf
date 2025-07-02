provider "aws" {
  region  = "ap-south-1"
  profile = "kailas"
}

module "network" {
  source          = "./modules/network"
  vpc_cidr        = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "iam" {
  source = "./modules/iam"
}

resource "aws_cloudwatch_log_group" "batch_logs" {
  name              = "/aws/batch/job"
  retention_in_days = 7
}

module "batch" {
  source                 = "./modules/batch"
  private_subnets        = module.network.private_subnets
  security_group_id      = module.network.security_group_id
  batch_service_role_arn = module.iam.batch_service_role_arn
  execution_role_arn     = module.iam.execution_role_arn
  container_image        = "amazonlinux"
  command                = ["echo", "Hello from AWS Batch Fargate"]
  log_group              = aws_cloudwatch_log_group.batch_logs.name
  aws_region             = "ap-south-1"
}
