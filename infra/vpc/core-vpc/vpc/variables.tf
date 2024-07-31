variable "prefix" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.100.10.0/24"
}

variable "subnet_gw" {
  type    = string
  default = "10.100.10.1"
}

variable "region" {
  type    = string
}

variable "tags" {}
