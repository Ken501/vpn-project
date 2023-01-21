// Common Variables

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access key"
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret key"
  type = string
}

variable "AWS_REGION" {
  description = "AWS preferred region"
  type = string
}

variable "app_name" {
  description = "Application name"
  type = string
}

variable "environment" {
  description = "Application lifecycle stage"
  type = string
}

variable "additional_tags" {
  default     = {}
  description = "Tags used to identify the project and environment"
  type        = map(string)
}

// Backend variables

variable "backend_bucket" {
  description = "Terraform backend bucket name"
}

// VPC Peering variables
// VPC Peer 1

variable "peer_id_1" {
  description = "Account id of accepter vpc"
}

variable "peer_vpc_id_1" {
  description = "VPC id of accepter vpc"
}

// Peer 2

variable "peer_id_2" {
  description = "Account id of accepter vpc"
}

variable "peer_vpc_id_2" {
  description = "VPC id of accepter vpc"
}

// Peer 3

variable "peer_id_3" {
  description = "Account id of accepter vpc"
}

variable "peer_vpc_id_3" {
  description = "VPC id of accepter vpc"
}

// EC2 Instance variables

variable "instance_type" {
  description = "Default instance type"
  default     = "t2.micro"
}