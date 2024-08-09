provider "aws" {
  region = var.REGION
}

resource "aws_instance" "ec2-wordpress" {
  ami                         = var.AMIS[var.REGION]
  instance_type               = "t3.micro"
  availability_zone           = var.ZONE1
  subnet_id                   = "subnet-0e0208e029736433c"
  key_name                    = "wordpress"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]


  tags = {
    Name = "wordpress-ec2"
  }


  user_data = file("web.sh")

#   provisioner "file" {
#     source      = "web.sh"
#     destination = "/etc/web.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod u+x /etc/web.sh",
#       "sudo /etc/web.sh"
#     ]

#   }

#   connection {
#     type        = "ssh"
#     user        = var.USER
#     private_key = file("wordpress.pem")
#     host        = self.public_ip

#   }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-wrd-press-security-group"
  description = "ec2-security-group"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-http/ssh"
  }
}

output "PublicIP" {
  value = aws_instance.ec2-wordpress.public_ip
}