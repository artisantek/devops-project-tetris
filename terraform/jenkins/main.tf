# Security Group for Jenkins Master
resource "aws_security_group" "jenkins_master_sg" {
  name = "jenkins-master-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080  
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from anywhere (replace with your desired IP range)
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere (replace with your desired IP range)
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Security Group for Jenkins Agent
resource "aws_security_group" "jenkins_agent_sg" {
  name = "jenkins-agent-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] # Replace with your desired IP range
  }

  # Add additional ingress rules for specific ports required by Jenkins Agent
  # For example, if the Agent needs to communicate with EKS on port 443:
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] # Replace with your desired IP range
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Jenkins Master EC2 Instance
resource "aws_instance" "jenkins_master" {
  ami           = var.jenkins_master_ami
  instance_type = var.jenkins_master_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.jenkins_master_sg.id,
  ]

  tags = {
    Name = var.jenkins_master_name
  }
}

# Jenkins Agent EC2 Instance
resource "aws_instance" "jenkins_agent" {
  ami           = var.jenkins_agent_ami
  instance_type = var.jenkins_agent_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.jenkins_agent_sg.id,
  ]

  tags = {
    Name = var.jenkins_agent_name
  }
}