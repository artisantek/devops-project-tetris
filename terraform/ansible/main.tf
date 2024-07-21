data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ansible_controller_sg" {
  name = "ansible-controller-sg"
  vpc_id      = data.aws_vpc.default.id

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

resource "aws_instance" "ansible_controller" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.ansible_controller_sg.id,
  ]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install git -y
              sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
              sudo yum install ansible-core -y
              ansible-galaxy collection install community.docker
              EOF

  # Copy local .pem file to .ssh/id_rsa on the EC2 instance
  provisioner "file" {
    source      = "./november2023.pem"
    destination = "/home/ec2-user/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./november2023.pem")
      host        = self.public_ip
    }
  }

  # Set the correct permissions on the id_rsa file
  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/.ssh/id_rsa"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./november2023.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = var.ansible_controller_name
  }
}
