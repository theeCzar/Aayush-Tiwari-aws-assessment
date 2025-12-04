provider "aws" {
  region = "us-east-1"
}

# --- CONFIGURATION ---
locals {
  name_prefix = "Aayush_Tiwari" 
  
  # AMI ID for Amazon Linux 2023 (us-east-1)
  ami_id = "ami-0230bd60aa48260c6" 
}

# --- 1. DATA SOURCES (Finding Q1 Resources) ---
# This looks up the VPC created in Q1 by its Name tag
data "aws_vpc" "q1_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}_VPC"]
  }
}

# This looks up Public Subnet 1 created in Q1 by its Name tag
data "aws_subnet" "q1_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}_Public_Subnet_1"]
  }
}

# --- 2. SECURITY GROUP (HARDENED) ---
resource "aws_security_group" "web_sg" {
  name        = "${local.name_prefix}_Web_SG"
  description = "Allow HTTP traffic only"
  vpc_id      = data.aws_vpc.q1_vpc.id

  # Inbound Rule: HTTP (Port 80) - Allowed from anywhere
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Hardening: SSH (Port 22) is NOT enabled globally. 
  # If you need to debug, add a specific ingress rule for your IP only.

  # Outbound Rule: Allow all traffic (needed for yum install)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}_Web_SG"
  }
}

# --- 3. EC2 INSTANCE ---
resource "aws_instance" "web_server" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.q1_subnet.id
  
  # Attach the Security Group
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  # Auto-assign Public IP so we can view the website
  associate_public_ip_address = true

  # Hardening: Enforce IMDSv2 (Token required)
  metadata_options {
    http_tokens = "required"
  }

  # --- USER DATA (The Script) ---
  user_data = <<-EOF
              #!/bin/bash
              # 1. Update the OS
              yum update -y
              
              # 2. Install Nginx
              yum install nginx -y
              
              # 3. Create a simple Resume HTML file
              cat <<EOT > /usr/share/nginx/html/index.html
              <html>
              <head><title>${local.name_prefix} Resume</title></head>
              <body style="font-family: sans-serif; padding: 20px;">
                  <h1>${local.name_prefix}</h1>
                  <h3>Cloud Engineer | AWS & Terraform</h3>
                  <hr>
                  <h4>Summary</h4>
                  <p>Aspiring Cloud Engineer with hands-on experience in AWS infrastructure and IaC.</p>
                  <h4>Skills</h4>
                  <ul>
                      <li>AWS (VPC, EC2, S3)</li>
                      <li>Terraform & Infrastructure as Code</li>
                      <li>Linux & Scripting</li>
                  </ul>
              </body>
              </html>
              EOT
              
              # 4. Start and Enable Nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "${local.name_prefix}_Resume_Server"
  }
}

output "website_url" {
  value = "http://${aws_instance.web_server.public_ip}"
  description = "Click this URL to view the resume"
}
