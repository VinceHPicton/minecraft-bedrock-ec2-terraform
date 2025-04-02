
resource "aws_instance" "minecraft" {
  ami        = "ami-0f0e66c76d71b6ab2"
  instance_type   = "c7i.large"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = filebase64("./userdata.sh")

  associate_public_ip_address = true
}

resource "aws_eip" "server-ip" {
  domain = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.minecraft.id
  allocation_id = aws_eip.server-ip.id
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.IPv4_port
    to_port     = var.IPv6_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "IPv4_port" {
  description = "The port the server will use for UDP IPv4 requests"
  type        = number
  default     = 19132
}

variable "IPv6_port" {
  description = "The port the server will use for UDP IPv6 requests"
  type        = number
  default     = 19133
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_vpc" "default" {
  default = true
}