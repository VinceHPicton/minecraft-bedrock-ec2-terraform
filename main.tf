
resource "aws_instance" "minecraft" {
  ami        = data.aws_ami.latest_mc_bedrock_ami.id
  instance_type   = "c7i.large"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = filebase64("./userdata.sh")

  associate_public_ip_address = true
}

data "aws_ami" "latest_mc_bedrock_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["minecraft-bedrock-*"] # Match AMI names created by Packer
  }
}

data "aws_eip" "mc-server-test-ip" {
  filter {
    name   = "tag:Name"
    values = ["MC-test-IP"]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.minecraft.id
  allocation_id = data.aws_eip.mc-server-test-ip.id
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