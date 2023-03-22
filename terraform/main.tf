#  This file contains the terraform code for the blockchain client




# AWS IAM role resource for the ECS task execution role.
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# AWS IAM role policy attachment resource for the ECS task execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

# AWS IAM role resource for the ECS task role.
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# AWS IAM policy resource for the ECS task role.
resource "aws_iam_policy" "ecs_task_policy" {
  name = "ecs_task_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# AWS IAM role policy attachment resource for the ECS task role.
resource "aws_iam_role_policy_attachment" "ecs_task_attachment" {
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}


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

# AWS IAM role policy attachment resource for the ECS service.
resource "aws_iam_role_policy_attachment" "ecs_service_attachment" {
  policy_arn = aws_iam_policy.ecs_service_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

# AWS IAM policy resource for the ECS service.
resource "aws_iam_policy" "ecs_service_policy" {
  name = "ecs_service_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:RunTask"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# AWS Security Group resource for the blockchain client service.
resource "aws_security_group" "lb_sg" {
  name_prefix = "lb-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# AWS ECS service resource for the blockchain client service.
resource "aws_ecs_service" "blockchain_client_service" {
  name            = var.service_name
  cluster         = "default"
  task_definition = aws_ecs_task_definition.blockchain_client_task.arn
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.ecs_security_group.id]
    subnets         = module.vpc.public_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blockchain_client_target_group.arn
    container_name   = "blockchain-client"
    container_port   = 8000
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_service_attachment]
}

# AWS Application Load Balancer target group resource for the blockchain client service.
resource "aws_lb_target_group" "blockchain_client_target_group" {
  name        = "blockchain-client-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    path     = "/"
    port     = 8000
    protocol = "HTTP"
  }

  vpc_id = module.vpc.vpc_id
}

# AWS Application Load Balancer listener resource for the blockchain client service.
resource "aws_lb_listener" "blockchain_client_listener" {
  load_balancer_arn = aws_lb.blockchain_client_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.blockchain_client_target_group.arn
    type             = "forward"
  }
}

# AWS Application Load Balancer resource for the blockchain client service.
resource "aws_lb" "blockchain_client_lb" {
  name               = "blockchain-client-lb"
  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.lb_sg.id]
  internal        = false
  idle_timeout    = 400

  tags = {
    Name = "blockchain-client-lb"
  }
}








