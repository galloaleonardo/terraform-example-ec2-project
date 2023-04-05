variable "region" {
  type = string
}

variable "vpc" {
  type = object({
    cidr_block = string
    tag_name   = string
  })
}

variable "route_table" {
  type = object({
    cidr_block      = string
    ipv6_cidr_block = string
    tag_name        = string
  })
}

variable "subnet" {
  type = object({
    cidr_block        = string
    availability_zone = string
    tag_name          = string
  })
}

variable "security_group" {
  type = object({
    name        = string
    description = string
    tag_name    = string

    ingress_https = object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })

    ingress_http = object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })

    ingress_ssh = object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })

    egress = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })
  })
}

variable "network_interface" {
  type = object({
    private_ips = list(string)
  })
}

variable "eip" {
  type = object({
    vpc                       = bool
    associate_with_private_ip = string
  })
}

variable "ec2" {
  type = object({
    ami               = string
    instance_type     = string
    availability_zone = string
    key_name          = string
    tag_name          = string

    network_interface = object({
      device_index = number
    })

    user_data = string
  })
}