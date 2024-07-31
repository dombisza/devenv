# This file has been generated from ./tf_backend/main.tf:null_resource
terraform {
  required_version = "<=1.5.5, >=v1.4.6"
  backend "s3" {
    endpoint                    = "obs.eu-nl.otc.t-systems.com"
    bucket                      = "sdombi-rnd-state"
    key                         = "personal/obs-services-vpc"
    skip_region_validation      = true
    skip_credentials_validation = true
    region                      = "eu-nl"
   }
   required_providers {
     opentelekomcloud = {
     source  = "opentelekomcloud/opentelekomcloud"
     version = ">=1.35.6"
     }
   }
}
