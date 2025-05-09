
resource "aws_instance" "minecraft" {
  ami        = data.aws_ami.latest_mc_bedrock_ami.id
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = aws_subnet.public_subnet.id

  user_data = filebase64("./userdata.sh")

  associate_public_ip_address = true
  ipv6_address_count     = 1

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "MC-server"
  }
}

output "instance_ipv6" {
  value = aws_instance.minecraft.ipv6_addresses
}
