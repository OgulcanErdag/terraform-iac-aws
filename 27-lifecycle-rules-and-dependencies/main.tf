# Up to Terraform v0.15.1
# terraform taint aws_instance.node2
#
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "node1" {
  ami           = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-1"
    Owner = "Ogulcan"
  }
}

resource "aws_instance" "node2" {
  ami           = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-2"
    Owner = "Ogulcan"
  }
}

resource "aws_instance" "node3" {
  ami           = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-3"
    Owner = "Ogulcan"
  }
  depends_on = [aws_instance.node2]
}
