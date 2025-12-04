provider "aws" {
  region = "us-east-1"
}

locals {
  name_prefix = "Aayush_Tiwari" 
  ami_id      = "ami-0230bd60aa48260c6" # Amazon Linux 2023
}

# --- 1. DATA SOURCES (Fetch Q1 Network) ---
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}_VPC"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}_Public_Subnet_*"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}_Private_Subnet_*"]
  }
}

# --- 2. SECURITY GROUPS ---

# ALB SG: Open to World (HTTP)
resource "aws_security_group" "alb_sg" {
  name        = "${local.name_prefix}_ALB_SG"
  description = "Allow HTTP to Load Balancer"
  vpc_id      = data.aws_vpc.main.id

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

  tags = { Name = "${local.name_prefix}_ALB_SG" }
}

# Instance SG: Closed to World, Open ONLY to ALB
resource "aws_security_group" "instance_sg" {
  name        = "${local.name_prefix}_Instance_SG"
  description = "Allow HTTP from ALB only"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Security Chaining
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name_prefix}_Instance_SG" }
}

# --- 3. LOAD BALANCER (ALB) ---
resource "aws_lb" "app_lb" {
  name               = "app-lb-q3" 
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.public.ids

  tags = { Name = "${local.name_prefix}_ALB" }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg-q3"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
  
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# --- 4. LAUNCH TEMPLATE ---
resource "aws_launch_template" "app_lt" {
  name_prefix   = "${local.name_prefix}_LT"
  image_id      = local.ami_id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.instance_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install nginx -y
              echo "<h1>${local.name_prefix} - HA Architecture</h1>" > /usr/share/nginx/html/index.html
              systemctl start nginx
              systemctl enable nginx
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.name_prefix}_ASG_Instance"
    }
  }
}

# --- 5. AUTO SCALING GROUP (ASG) ---
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  vpc_zone_identifier = data.aws_subnets.private.ids
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}_ASG_Instance"
    propagate_at_launch = true
  }
}

# --- OUTPUTS ---
output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
  description = "Access the website here"
}
