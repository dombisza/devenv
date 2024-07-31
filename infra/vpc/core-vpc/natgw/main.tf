resource "opentelekomcloud_vpc_eip_v1" "this" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.prefix}-bw"
    size        = 100
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "opentelekomcloud_nat_gateway_v2" "this" {
  name                = "${var.prefix}-gw"
  description         = "NAT GW created by terraform"
  spec                = "1"
  router_id           = var.vpc_id
  internal_network_id = var.network_id

}

resource "opentelekomcloud_nat_snat_rule_v2" "snat_1" {
  nat_gateway_id = opentelekomcloud_nat_gateway_v2.this.id
  floating_ip_id = opentelekomcloud_vpc_eip_v1.this.id
  cidr           = var.cidr
  source_type    = 0
}
