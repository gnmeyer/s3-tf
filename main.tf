terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "awsbucket-grant"
    key    = "state "
    region = "us-east-1"
  }

  required_version = ">= 1.2.0"

}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  count         = 1
  ami           = "ami-0fe630eb857a6ec83"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["sg-0664e17c27dc38c48"]

  subnet_id = "subnet-019c03f7b62349192"

  tags = {
    Name = var.instance_name
  }
}