## [BASTION]

data "opentelekomcloud_images_image_v2" "ubuntu" {
  name = "Standard_Ubuntu_22.04_latest"
}

resource "opentelekomcloud_networking_secgroup_v2" "this" {
  name = "bastion"
  description = "bastion allow 22"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "this" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.this.id
}

resource "opentelekomcloud_vpc_eip_v1" "bastion" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.prefix}-bastion"
    size        = 8
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "opentelekomcloud_networking_floatingip_associate_v2" "ubuntu_fip" {
  floating_ip = opentelekomcloud_vpc_eip_v1.bastion.publicip.0.ip_address
  port_id = opentelekomcloud_ecs_instance_v1.bastion.nics.0.port_id
}

resource "opentelekomcloud_ecs_instance_v1" "bastion" {
  name     = "${var.prefix}-bastion"
  image_id = data.opentelekomcloud_images_image_v2.ubuntu.id
  flavor   = "s3.large.2"
  vpc_id   = var.vpc_id
  security_groups   = [opentelekomcloud_networking_secgroup_v2.this.id]
  system_disk_type = "SAS"
  system_disk_size = 40
  nics {
    #network_id =  opentelekomcloud_vpc_subnet_v1.this.network_id
    network_id = var.network_id
  }

  availability_zone = var.az
  key_name          = var.key_name 

  tags = var.tags
}

output "bastion_ip" {
  value = opentelekomcloud_vpc_eip_v1.bastion.publicip.0.ip_address
}
