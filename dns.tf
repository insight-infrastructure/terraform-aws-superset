variable "create_dns" {
  description = "Bool to create dns record"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The domain name"
  type        = string
  default     = ""
}

variable "hostname" {
  description = "The hostname - ie hostname.example.com"
  type        = string
  default     = ""
}

data "aws_route53_zone" "this" {
  count = var.domain_name != "" && var.create_superset ? 1 : 0
  name  = var.domain_name
}

resource "aws_route53_record" "this" {
  count = var.domain_name != "" && var.hostname != "" && var.create_superset ? 1 : 0

  name    = "${var.hostname}.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  zone_id = join("", data.aws_route53_zone.this.*.id)
  records = [join("", aws_eip.this.*.public_ip)]
}
