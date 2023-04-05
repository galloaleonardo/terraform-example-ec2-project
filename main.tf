provider "aws" {
  region = var.region
}

# 1. Create vpc

resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc.cidr_block
  tags = {
    Name = var.vpc.tag_name
  }
}

# 2. Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# 3. Create Custom Route Table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = var.route_table.cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = var.route_table.ipv6_cidr_block
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.route_table.tag_name
  }
}

# 4. Create a Subnet 

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet.cidr_block
  availability_zone = var.subnet.availability_zone

  tags = {
    Name = var.subnet.tag_name
  }
}

# 5. Associate subnet with Route Table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow port 22,80,443

resource "aws_security_group" "allow_web" {
  name        = var.security_group.name
  description = var.security_group.description
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = var.security_group.ingress_https.description
    from_port   = var.security_group.ingress_https.from_port
    to_port     = var.security_group.ingress_https.to_port
    protocol    = var.security_group.ingress_https.protocol
    cidr_blocks = var.security_group.ingress_https.cidr_blocks
  }

  ingress {
    description = var.security_group.ingress_http.description
    from_port   = var.security_group.ingress_http.from_port
    to_port     = var.security_group.ingress_http.to_port
    protocol    = var.security_group.ingress_http.protocol
    cidr_blocks = var.security_group.ingress_http.cidr_blocks
  }

  ingress {
    description = var.security_group.ingress_ssh.description
    from_port   = var.security_group.ingress_ssh.from_port
    to_port     = var.security_group.ingress_ssh.to_port
    protocol    = var.security_group.ingress_ssh.protocol
    cidr_blocks = var.security_group.ingress_ssh.cidr_blocks
  }

  egress {
    from_port   = var.security_group.egress.from_port
    to_port     = var.security_group.egress.to_port
    protocol    = var.security_group.egress.protocol
    cidr_blocks = var.security_group.egress.cidr_blocks
  }

  tags = {
    Name = var.security_group.tag_name
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = var.network_interface.private_ips
  security_groups = [aws_security_group.allow_web.id]

}

# 8. Assign an elastic IP to the network interface created in step 7

resource "aws_eip" "one" {
  vpc                       = var.eip.vpc
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.eip.associate_with_private_ip
  depends_on                = [aws_internet_gateway.gw]
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}

# 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
  ami               = var.ec2.ami
  instance_type     = var.ec2.instance_type
  availability_zone = var.ec2.availability_zone
  key_name          = var.ec2.key_name

  network_interface {
    device_index         = var.ec2.network_interface.device_index
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = var.ec2.user_data

  tags = {
    Name = var.ec2.tag_name
  }
}