variable "private_subnets" {
  type = list(string)
}
variable "security_group_id" {}
variable "batch_service_role_arn" {}
variable "execution_role_arn" {}
variable "container_image" {}
variable "command" {
  type = list(string)
}
variable "log_group" {}
variable "aws_region" {}