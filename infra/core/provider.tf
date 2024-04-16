provider "opentelekomcloud" {
  auth_url = "https://iam.${var.region}.otc.t-systems.com/v3"
  tenant_name    = var.project_name 
  domain_name    = var.domain_name 
  security_token = var.ak_sk_security_token
}
