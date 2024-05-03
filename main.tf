terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }

  backend "s3" {
    bucket = "awsbucket-grant"
    key    = "state "
    region = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  count         = 1 #Finches, please modify the count for testing purposes
  ami           = "ami-0fe630eb857a6ec83"
  instance_type = "t2.micro"

  #vpc_security_group_ids = ["sg-0664e17c27dc38c48"]

  #subnet_id = "subnet-019c03f7b62349192"

  tags = {
    Name = var.instance_name
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.vpc_tags
}