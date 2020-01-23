# variables

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "aws_region" {
  default = "us-west-2"
}

# providers

provider "aws" {

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# data

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }
  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# resources

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "allow ssh" {
  name        = "nginx_demo"
  description = "allow ports for nginx demo"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
}
}

