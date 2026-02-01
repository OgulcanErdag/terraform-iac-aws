# Auto Fill variables for PROD

#File names can be  as:
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars


region                     = "us-east-1"
instance_type              = "t3.micro"
enable_detailed_monitoring = true

allow_ports = ["80", "443"]

common_tags = {
  Owner       = "Ogulcan"
  Project     = "Phoenix"
  CostCenter  = "123477"
  Environment = "prod"
}
