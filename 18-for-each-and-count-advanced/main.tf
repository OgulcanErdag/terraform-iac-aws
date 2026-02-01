#----------------------------------------------------------
# My Terraform
#
# Terraform Loops: Count and For if
#
# Made by Ogulcan
#----------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_user" "user1" {
  name = "pushkin"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

#----------------------------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}
