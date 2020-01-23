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

resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.aws-linux-id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  
  connection {
    type        = "ssh"
    host        = "self.public_.ip"
    user        = "ec2-user"
    private_key = file(var.provate_key_path)
}

  provisioner {
    inline = [
      "sudo yum install nginx -y"
      "sudo service nginx start"
    ]
  }
}

# output

output "aws_instance_public_dns" {
  value = aws_instance.nginx.public_dns
}


