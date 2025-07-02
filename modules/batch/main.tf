resource "aws_batch_compute_environment" "fargate_compute" {
  name = "fargate-batch"

  compute_resources {
    max_vcpus          = 16
    security_group_ids = [var.security_group_id]
    subnets            = var.private_subnets
    type               = "FARGATE"
  }

  service_role = var.batch_service_role_arn
  type         = "MANAGED"
}


resource "aws_batch_job_queue" "job_queue" {
  name     = "batch-job-queue"
  state    = "ENABLED"
  priority = 1

  scheduling_policy_arn = null # Optional if no policy

  compute_environment_order {
    order                  = 1
    compute_environment     = aws_batch_compute_environment.fargate_compute.arn
  }
}

resource "aws_batch_job_definition" "job_def" {
  name = "fargate-job-def"
  type = "container"

  platform_capabilities = ["FARGATE"]

  container_properties = jsonencode({
    image       = var.container_image
    vcpus       = 1
    memory      = 2048
    command     = var.command
    executionRoleArn = var.execution_role_arn
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "batch"
      }
    }
  })
}
