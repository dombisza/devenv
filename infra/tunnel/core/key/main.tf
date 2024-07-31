resource "opentelekomcloud_compute_keypair_v2" "import-keypair" {
  name       = "home-rsa"
  public_key = file("${path.module}/id_rsa.pub") 
}

output "key_name" {
  value = opentelekomcloud_compute_keypair_v2.import-keypair.name
}
