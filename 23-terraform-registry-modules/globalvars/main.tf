#----------------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#
# Made by Ogulcan
#----------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "Ogulcan-Erdag-project-kgb-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

#==================================================

output "company_name" {
  value = "ANDESA Soft International"
}

output "owner" {
  value = "Ogulcan"
}

output "tags" {
  value = {
    Project    = "Assembly-2020"
    CostCenter = "R&D"
    Country    = "Canada"
  }
}
