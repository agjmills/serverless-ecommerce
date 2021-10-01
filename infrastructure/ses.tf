resource "aws_ses_domain_identity" "ecommerce" {
  domain = var.domain_name
}

resource "aws_route53_record" "ecommerce_verification_record" {
  zone_id    = data.aws_route53_zone.ecommerce.id
  type    = "TXT"
  name = "_amazonses.${var.domain_name}"
  ttl = "600"
  records = [aws_ses_domain_identity.ecommerce.verification_token]
}

resource "aws_ses_domain_dkim" "ecommerce-dkim" {
  domain = aws_ses_domain_identity.ecommerce.domain
}

resource "aws_route53_record" "ecommerce_amazonses_dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.ecommerce.id
  name    = "${element(aws_ses_domain_dkim.ecommerce-dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.ecommerce-dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_ses_domain_mail_from" "ecommerce-from-domain" {
  domain           = aws_ses_domain_identity.ecommerce.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.ecommerce.domain}"
}


resource "aws_route53_record" "ecommerce_ses_domain_mail_from_txt" {
  zone_id = data.aws_route53_zone.ecommerce.id
  name    = aws_ses_domain_mail_from.ecommerce-from-domain.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}
