#  Blockchain Client
This repository contains a simple Python-based blockchain client for the Blockchain network. It provides an easy-to-use command-line interface to interact with the Blockchain network using JSON-RPC API.


### For Golang implementation

![Golang Implementation](https://cdn.dribbble.com/userupload/2624050/file/original-59266f4dea1c2aa43f2064cc0f3b165a.png?resize=50x50)

[Golang Blockchain Client Source Code](https://github.com/moeidsaleem/tw-blockchain-client-go.git)




## Overview 

The python source code is located in the `/app` folder. Also setup the logs for each response. The `Dockerfile` mainly used to setup image.
The code then moves to the terraform configuration where you will need to deploy the infrastructure and alongside by setting up the `container_definition.json`, you can simply deploy this application
on ECS Fargate. 

## Requirements
Python 3.9 or later
Docker
Terraform
An AWS account

## Installation
1. Clone the repository:
```
git clone https://github.com/moeidsaleem/tw-blockchain-client-python.git
cd tw-blockchain-client-python
```

2. Create a Python virtual environment and activate it:
``` 
python3 -m venv venv
source venv/bin/activate 
```

3. Install the required Python packages:
``` 
pip install -r app/requirements.txt
```

4. Run the application locally:
``` 
python app/main.py
```

## Building the Docker Image
To build a Docker image for the application, run the following command from the root of the repository:

``` 
docker build -t blockchain-client .
```

To run the Docker container locally:

```
docker run --rm -it blockchain-client
```

## Deploying to AWS ECS Fargate using Terraform

Please setup your AWS environment variables or update it in deploy.sh. 

I have setup `terraform/deploy.sh` file that will do complete terraform process i.e. from initilization to setting up example variables and deployment. 
``` bash
sh deploy.sh
```


### Manual setup

1. Navigate to the terraform directory:
`cd terraform`


2. Initialize the Terraform working directory:

```
terraform init
```

3. Plan the Terraform changes:
```
terraform plan
```

Apply the Terraform changes:
```
terraform apply
```

This will create the necessary AWS resources and deploy the application to AWS ECS Fargate.


## Main task reference for terraform

The terraform configuration will deploy all the necessary AWS infrastructure to run the project efficiently. The code is kept lightweight and can be easily modularized using **/modules**. The Terraform folder includes essential files such as `main.tf`, `providers.tf`, `security.tf`, `variables.tf`, and `vpc.tf`, along with other helpful resources such as `.tfvars.example`, `deploy.sh`, and `container_definition.json`. For quick reference on container setup, please check `main.tf lines 75-88`.


Here is the main code snippet 
``` h
# AWS ECS task definition resource for the blockchain client service. (* main task definition *)
resource "aws_ecs_task_definition" "blockchain_client_task" {
  family                   = "blockchain-client-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode(
    jsondecode(file("${path.module}/container_definition.json"))
  )
}
```

The container definition file is kept seperate for automation, The file is as followed:
``` JSON
[
    {
      "name": "blockchain-client",
      "image": "${var.docker_image_repo}:latest",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${var.aws_region}",
          "awslogs-group": "blockchain-client",
          "awslogs-stream-prefix": "blockchain-client"
        }
      }
    }
  ]
  ```


## Production-Readiness Considerations
To make this application production-ready, consider the following:

- Add proper logging and monitoring to gain insights into the application's performance and to detect issues early.
- Implement retry mechanisms and error handling to ensure the application is resilient to network failures or other errors.
- Use a proper configuration management system to manage environment-specific settings and credentials securely.
- Ensure the security of the application, including securing sensitive data and applying best practices for network and infrastructure security.
- Scale the infrastructure as needed to handle increased workloads and maintain performance.



##  Author

<img src="https://yt3.googleusercontent.com/LN0J3J7S-3QBM6LcjE6C43O7sG9UOW38srqPQAlovovNi_xBjqo4MqSmvlpCzffXbAUwZVR2c50=s900-c-k-c0x00ffffff-no-rj" width="120" height="120" style="border-radius:300px" />

Moeid Saleem Khan (Mo) 🚀