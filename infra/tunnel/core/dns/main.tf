resource "opentelekomcloud_dns_zone_v2" "this" {
  name = var.domain
  email = var.email
  description = "tf managed zone for grafana"
  ttl = 300
  type = "public"
}

resource "opentelekomcloud_dns_recordset_v2" "this" {
  zone_id     = opentelekomcloud_dns_zone_v2.this.id
  name        = "${var.sub_domain}.${var.domain}"
  description = "grafana"
  ttl         = 300
  type        = "A"
  records     = [var.elb_ip]
}
