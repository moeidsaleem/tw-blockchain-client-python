# This file is used to define the providers that will be used in the terraform code



# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }

#   required_version = ">= 1.0"
# }

provider "aws" {
  region = var.region
}
