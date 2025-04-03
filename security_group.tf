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