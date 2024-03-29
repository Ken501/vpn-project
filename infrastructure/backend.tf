// Configure terraform backend
terraform {
  backend "s3" {
    bucket = var.backend_bucket
    key    = "${var.environment}/${var.app_name}/infrastructure/${var.AWS_REGION}"
    region = var.AWS_REGION
  }
}