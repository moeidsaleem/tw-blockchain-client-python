# Deployment of Blockchain Client on AWS ECS Fargate using Terraform

This implementation deploys the blockchain client application in a container on AWS ECS Fargate using Terraform.

## Prerequisites
- AWS account
- Terraform installed
- Files



## Files 

 This implementation includes the following files:

1. main.tf: This file contains the main Terraform configuration for deploying the blockchain client application on AWS ECS Fargate. It defines the ECS task configuration.

2. variables.tf: This file defines the variables required for the Terraform configuration. It includes variables such as the AWS region, VPC CIDR block, subnets CIDR blocks, and ECS container definition.
outputs.tf: This file defines the output variables that are useful for retrieving the details of the deployed resources.

3. container_definition.json: This file defines the Fargate task definition for the blockchain client container. It specifies the Docker image, memory and CPU requirements, and environment variables.

4. .tfvars.example: This file defines the values for the variables defined in variables.tf. This file should be created by the user and the values should be filled in.

5. vpc.tf: This file defines the VPC, subnets, and internet gateway required for the blockchain client application. It creates a VPC with public subnets and an internet gateway that allows inbound and outbound traffic.

6. providers.tf: This file defines the provider for the Terraform configuration. In this implementation, it specifies the AWS provider and the region where the resources should be created.

7. backend.tf: This file defines the backend configuration for Terraform (currently local backend)