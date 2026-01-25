#----------------------------------------------------------
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Ogulcan
#----------------------------------------------------------


provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_instance" "my_webserver" {
  ami                         = "ami-07ff62358b87c7116"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.my_webserver.id]
  user_data_replace_on_change = true # This need to added!!!!  
  user_data                   = <<EOF
            #!/bin/bash
            dnf update -y
            dnf upgrade -y
            dnf install -y httpd

            TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
            -H "X-aws-ec2-metadata-token-ttl-seconds: 600")

            myip=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
            http://169.254.169.254/latest/meta-data/local-ipv4)

            echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform! Owner Ogulcan." > /var/www/html/index.html

            systemctl start httpd
            systemctl enable httpd
            EOF

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Ogulcan"
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Ogulcan"
  }
}
