#----------------------------------------------------------
# Highly Available Web Server (ASG + ALB)
# Made by Ogulcan
#----------------------------------------------------------

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Owner     = "Ogulcan"
      CreatedBy = "Terraform"
      Course    = "From Zero to Certified Professional"
    }
  }
}

#----------------------------------------------------------
# Availability Zones
data "aws_availability_zones" "available" {}

#----------------------------------------------------------
# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

#----------------------------------------------------------
# Default VPC & Subnets
resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#----------------------------------------------------------
# Security Group for ALB (Internet-facing)
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP from Internet"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------------------------------------------------------
# Security Group for EC2 (Only ALB can access)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP only from ALB"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------------------------------------------------------
# Launch Template
resource "aws_launch_template" "web" {
  name_prefix   = "web-lt-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = filebase64("${path.module}/user_data.sh")

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------------------------
# Target Group
resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  vpc_id   = aws_default_vpc.default.id
  port     = 80
  protocol = "HTTP"

  health_check {
    path                = "/"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

#----------------------------------------------------------
# Application Load Balancer
resource "aws_lb" "web" {
  name               = "web-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_default_subnet.az1.id,
    aws_default_subnet.az2.id
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

#----------------------------------------------------------
# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name              = "web-asg"
  min_size          = 2
  max_size          = 2
  desired_capacity  = 2
  health_check_type = "ELB"
  vpc_zone_identifier = [
    aws_default_subnet.az1.id,
    aws_default_subnet.az2.id
  ]
  target_group_arns = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "WebServer-ASG"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------------------------
# Output
output "alb_dns_name" {
  value       = aws_lb.web.dns_name
  description = "Application Load Balancer DNS"
}
