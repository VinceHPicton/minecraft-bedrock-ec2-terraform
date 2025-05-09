data "aws_route53_zone" "main" {
  name = "vince.ckparsons.co.uk."
}

resource "aws_route53_record" "minecraft_aaaa" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "minecraft.vince.ckparsons.co.uk"
  type    = "AAAA"
  ttl     = 300
  records = [aws_instance.minecraft.ipv6_addresses[0]]
}
