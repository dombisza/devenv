## [NETWORK]

resource "opentelekomcloud_vpc_v1" "this" {
  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr
  tags = var.tags
}

resource "opentelekomcloud_vpc_subnet_v1" "this" {
  name       = "${var.prefix}-subnet"
  cidr       = var.subnet_cidr
  vpc_id     = opentelekomcloud_vpc_v1.this.id
  gateway_ip = var.subnet_gw

  tags = var.tags
}

output "vpc_id" {
  value = opentelekomcloud_vpc_v1.this.id
}

output "subnet_id" {
  value = opentelekomcloud_vpc_subnet_v1.this.id
}

output "network_id" {
  value = opentelekomcloud_vpc_subnet_v1.this.network_id
}

output "cidr" {
  value = opentelekomcloud_vpc_subnet_v1.this.cidr
}
