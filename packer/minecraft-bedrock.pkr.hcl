packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "c7i.large"
  region        = "eu-west-2"
  source_ami    = "ami-0a94c8e4ca2674d5a"
  ssh_username  = "ubuntu"
}

build {
  name = "minecraft-bedrock"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = local.start_server_script
    destination = "/tmp/${local.start_server_script}"
  }

  provisioner "shell" {
    inline = [
      "mv /tmp/${local.start_server_script} /home/ubuntu",
      "sudo chmod +x /home/ubuntu/${local.start_server_script}",
    ]
  }

  provisioner "file" {
    source      = local.bedrock_zip_file
    destination = "/tmp/${local.bedrock_zip_file}"
  }

  provisioner "shell" {
    inline = [
      "sudo apt install -y unzip",
      "unzip /tmp/${local.bedrock_zip_file} -d /home/ubuntu",
      "rm /tmp/${local.bedrock_zip_file}",
    ]
  }
}

variable "ami_prefix" {
  type    = string
  default = "minecraft-bedrock"
}

locals {
  timestamp        = regex_replace(timestamp(), "[- TZ:]", "")
  bedrock_zip_file = "bedrock-server-1.21.71.01.zip"
  start_server_script = "start_server.sh"
}