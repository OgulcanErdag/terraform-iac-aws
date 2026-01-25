provider "aws" {}


resource "aws_instance" "my_Ubuntu" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"

  tags = {
    Name    = "My Ubuntu Server"
    Owner   = "Ogulcan"
    Project = "Terraform Lessons"
  }
}

resource "aws_instance" "my_Amazon" {
  ami           = "ami-07ff62358b87c7116"
  instance_type = "t3.small"

  tags = {
    Name    = "My Amazon Server"
    Owner   = "Ogulcan"
    Project = "Terraform Lessons"
  }
}
