

data "aws_ami" "latest_mc_bedrock_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["minecraft-bedrock-*"] # Match AMI names created by Packer
  }
}