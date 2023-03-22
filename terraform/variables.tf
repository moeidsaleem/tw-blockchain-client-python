# This file contains the variables used in the terraform scripts


variable "region" {
  description = "The AWS region to use"
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks for the public subnets"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks for the private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones to use for the subnets"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks to use for the security groups"
}
variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "docker_image_repo" {
  description = "The name of the Docker image repository"
}

variable "aws_region" {
  description = "The AWS region to deploy the service to"
}

variable "service_name" {
  description = "The name of the ECS service"
}

