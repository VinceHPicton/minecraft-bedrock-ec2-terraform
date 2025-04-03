
resource "aws_instance" "minecraft" {
  ami        = data.aws_ami.latest_mc_bedrock_ami.id
  instance_type   = "c7i.large"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = filebase64("./userdata.sh")

  associate_public_ip_address = true
}