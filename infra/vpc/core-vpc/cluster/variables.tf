data "opentelekomcloud_identity_project_v3" "current" {}

variable "azs" {
  type = list
  default = ["eu-de-01", "eu-de-02"]
}

variable "metrics_version" {
  type = string
  default = "1.3.68"
}

variable "autoscaler_version" {
  type = string
  default = "1.30.18"
}

variable "everest_version" {
  type = string
  default = "2.4.28"
}

variable "prefix" {}
variable "vpc_id" {}
variable "subnet_id" {}

variable "node_os" {
  type = string
  default = "Ubuntu 22.04"
}

variable "node_flavor" {
  type = string
  default = "c4.xlarge.2"
}

variable "key_name" {}

variable "cnt" {
  type = string
  default = "vpc-router"
}

variable "auth_type" {
  type = string
  default = "rbac"
}

variable "proxy_mode" {
  type = string
  default = "iptables"
}

variable "scale_enabled" {
  type = bool
  default = true
}

variable "scaling" {
  type = map(number)
  default = {
    start = 2
    min = 2
    max = 2
  }
}

variable "root_vol" {
  type = number
  default = 40
}

variable "data_vol" {
  type = number
  default = 100
}

variable "cluster_version" {
  default = null
}
