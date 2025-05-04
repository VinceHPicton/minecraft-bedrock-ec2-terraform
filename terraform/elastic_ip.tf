

data "aws_eip" "mc-server-test-ip" {
  filter {
    name   = "tag:Name"
    values = ["MC-server-IP"]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.minecraft.id
  allocation_id = data.aws_eip.mc-server-test-ip.id
}