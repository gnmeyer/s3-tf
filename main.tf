terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.48.0"
    }
  }

  backend "s3" {
    bucket = "awsbucket-grant"
    key    = "state "
    region = "us-east-1"
  }
  required_version = "1.8.2"
}

provider "aws" {
  region = "us-east-1"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "5.8.1"


  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.vpc_tags
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"


  count = 2
  name  = "grant-ec2-cluster-${count.index}"

  ami                    = "ami-0fe630eb857a6ec83"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Name         = var.instance_name
    Client       = "Internal"
    Project      = "DOB"
    Owner        = "Grant"
    Applicaiton = "app_server"
    Environment  = "test"
  }
}

