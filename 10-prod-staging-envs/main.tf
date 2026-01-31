#----------------------------------------------------------
# My Terraform
#
# Find Latest AMI ID of:
#   - Ubuntu Server 22.04 LTS
#   - Amazon Linux 2023
#   - Windows Server 2022 Base
#
# Made by Ogulcan
#----------------------------------------------------------

provider "aws" {
  region = "ap-southeast-2"
}

#----------------------------------------------------------
# Ubuntu 22.04 LTS (Jammy)
#----------------------------------------------------------
data "aws_ami" "latest_ubuntu_2204" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

#----------------------------------------------------------
# Amazon Linux 2023
#----------------------------------------------------------
data "aws_ami" "latest_amazon_linux_2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

#----------------------------------------------------------
# Windows Server 2022 Base
#----------------------------------------------------------
data "aws_ami" "latest_windows_2022" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

#----------------------------------------------------------
# Outputs
#----------------------------------------------------------
output "ubuntu_2204_ami_id" {
  value = data.aws_ami.latest_ubuntu_2204.id
}

output "ubuntu_2204_ami_name" {
  value = data.aws_ami.latest_ubuntu_2204.name
}

output "amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}

output "amazon_linux_2023_ami_name" {
  value = data.aws_ami.latest_amazon_linux_2023.name
}

output "windows_2022_ami_id" {
  value = data.aws_ami.latest_windows_2022.id
}

output "windows_2022_ami_name" {
  value = data.aws_ami.latest_windows_2022.name
}

#----------------------------------------------------------
# Example Usage
#----------------------------------------------------------
/*
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_ubuntu_2204.id
  instance_type = "t3.micro"
}
*/
