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
  instance_type = "t2.micro"
  region        = "eu-west-2"
  ssh_username  = "ubuntu"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

}

build {
  name = "minecraft-bedrock"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y unzip curl zip",
      "mkdir -p /home/ubuntu/aws",
      "cd /home/ubuntu/aws",
      "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
    ]
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cp -r /tmp/scripts/* /home/ubuntu/",
      "chmod +x /home/ubuntu/*"
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

  provisioner "shell" {
    inline = [
      "echo '0 5,13,17 * * * /home/ubuntu/world_backup.sh' >> /tmp/cronjob",
      "crontab /tmp/cronjob",
    ]
  }
}

variable "ami_prefix" {
  type    = string
  default = "minecraft-bedrock"
}

locals {
  timestamp                = regex_replace(timestamp(), "[- TZ:]", "")
  bedrock_zip_file         = "bedrock-server-1.21.80.3.zip"
  minecraft_files_location = "/home/ubuntu"
}