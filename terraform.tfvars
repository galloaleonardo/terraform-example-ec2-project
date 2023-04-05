region = "us-east-1"

vpc = {
  cidr_block = "10.0.0.0/16"
  tag_name   = "production"
}

route_table = {
  cidr_block      = "0.0.0.0/0"
  ipv6_cidr_block = "::/0"
  tag_name        = "Prod"
}

subnet = {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tag_name          = "prod-subnet"
}

security_group = {
    name        = "allow_web_traffic"
    description = "Allow Web inbound traffic"
    tag_name    = "allow_web"

    ingress_https = {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress_http = {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress_ssh = {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

network_interface = {
  private_ips = ["10.0.1.50"]
}

eip = {
  vpc                       = true
  associate_with_private_ip = "10.0.1.50"
}

ec2 = {
  ami               = "ami-085925f297f89fce1"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "<your-key-name>"
  tag_name          = "web-server"

  network_interface = {
    device_index = 0
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
}