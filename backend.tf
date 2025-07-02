terraform {
  backend "s3" {
    bucket = "batch01-tf-state-bucket"
    key    = "fargate-batch/terraform.tfstate"
    region = "ap-south-1"
  }
}