# This file is used to create a VPC with public and private subnets

resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }

  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }

  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_internet_gateway" "ecs_gateway" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_gateway.id
  }

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

output "ecs_vpc_id" {
  value = aws_vpc.ecs_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  cidr = var.cidr_block
  azs  = var.availability_zones

  public_subnets  = var.public_subnet_cidr_blocks
  private_subnets = var.private_subnet_cidr_blocks

  tags = {
    Name = var.vpc_name
  }
}