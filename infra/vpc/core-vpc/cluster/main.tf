## [CCE CLUSTER]

data "opentelekomcloud_cce_addon_template_v3" "autoscaler" {
  addon_version = var.autoscaler_version
  addon_name    = "autoscaler"
}

data "opentelekomcloud_cce_addon_template_v3" "metrics" {
  addon_version = var.metrics_version
  addon_name    = "metrics-server"
}

# data "opentelekomcloud_cce_addon_templates_v3" "everest" {
# cluster_version = var.everest_version
# addon_name      = "everest"
# }

resource "opentelekomcloud_cce_cluster_v3" "this" {
  name                   = "${var.prefix}-cluster"
  cluster_type           = "VirtualMachine"
  flavor_id              = "cce.s1.small"
  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id
  container_network_type = var.cnt
  authentication_mode    = var.auth_type
  kube_proxy_mode        = var.proxy_mode
  eip                    = opentelekomcloud_vpc_eip_v1.this.publicip[0].ip_address
  cluster_version        = var.cluster_version
}

## [CCE NODEPOOLS]

resource "opentelekomcloud_cce_node_pool_v3" "this" {
  for_each                 = toset(var.azs)
  availability_zone        = each.key
  cluster_id               = opentelekomcloud_cce_cluster_v3.this.id
  name                     = "${var.prefix}-nodepool-v3-${each.key}"
  os                       = var.node_os
  flavor                   = var.node_flavor
  key_pair                 = var.key_name
  scale_enable             = var.scale_enabled
  initial_node_count       = var.scaling["start"]
  min_node_count           = var.scaling["min"]
  max_node_count           = var.scaling["max"]
  scale_down_cooldown_time = var.scale_enabled ? 100 : null
  priority                 = var.scale_enabled ? 1 : null
  runtime                  = "containerd"
  #  postinstall              = "c3VkbyB5dW0gaW5zdGFsbCBvcGVuLWlzY3NpIC15ICYmIHN1ZG8gc3lzdGVtY3RsIGVuYWJsZSBpc2NzaWQgJiYgc3VkbyBzeXN0ZW1jdGwgc3RhcnQgaXNjc2lkCg=="
  # lifecycle {
    # create_before_destroy = true
  # }
  root_volume {
    size       = var.root_vol
    volumetype = "SSD"
  }
  data_volumes {
    size       = var.data_vol
    volumetype = "SSD"
  }
  k8s_tags = {
    role = "general"
  }
}
# resource "opentelekomcloud_cce_node_pool_v3" "gvisor" {
  # availability_zone        = "eu-de-03"
  # cluster_id               = opentelekomcloud_cce_cluster_v3.this.id
  # name                     = "${var.prefix}-nodepool-sandbox"
  # os                       = var.node_os
  # flavor                   = "s3.xlarge.2"
  # key_pair                 = var.key_name
  # scale_enable             = var.scale_enabled
  # initial_node_count       = 4
  # min_node_count           = 4
  # max_node_count           = 4
  # scale_down_cooldown_time = var.scale_enabled ? 100 : null
  # priority                 = var.scale_enabled ? 1 : null
  # runtime                  = "containerd"
  # lifecycle {
    # create_before_destroy = true
  # }
  # root_volume {
    # size       = var.root_vol
    # volumetype = "SSD"
  # }
  # data_volumes {
    # size       = var.data_vol
    # volumetype = "SSD"
  # }
  # k8s_tags = {
    # sandbox = "true"
  # }
  # taints {
    # key    = "sandbox"
    # value  = "true"
    # effect = "NoSchedule"
  # }
# }


## [CCE KUBECONFIG]

#resource "null_resource" "get_kube_config" {
#  depends_on = [opentelekomcloud_cce_cluster_v3.this]
#  provisioner "local-exec" {
#    command = "./get_kube_config.sh"
#  }
#}

resource "opentelekomcloud_vpc_eip_v1" "this" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.prefix}-kube-master"
    size        = 300
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "opentelekomcloud_cce_addon_v3" "metrics" {
  template_name    = data.opentelekomcloud_cce_addon_template_v3.metrics.addon_name
  template_version = data.opentelekomcloud_cce_addon_template_v3.metrics.addon_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.this.id

  values {
    basic = {
      swr_addr = data.opentelekomcloud_cce_addon_template_v3.metrics.swr_addr
      swr_user = data.opentelekomcloud_cce_addon_template_v3.metrics.swr_user
    }
    custom = {}
  }
}


#https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/blob/master/modules/cce/addons.tf
resource "opentelekomcloud_cce_addon_v3" "autoscaler" {
  template_name    = data.opentelekomcloud_cce_addon_template_v3.autoscaler.addon_name
  template_version = data.opentelekomcloud_cce_addon_template_v3.autoscaler.addon_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.this.id

  values {
    basic = {
      swr_addr = data.opentelekomcloud_cce_addon_template_v3.autoscaler.swr_addr
      swr_user = data.opentelekomcloud_cce_addon_template_v3.autoscaler.swr_user
    }
    flavor = jsonencode({
      "replicas" = 1
      "resources" = [{
        "name"        = "autoscaler"
        "requestsCpu" = "100m"
        "requestsMem" = "200Mi"
        "limitsCpu"   = "500m"
        "limitsMem"   = "500Mi"
      }]
    })

    custom = {
      "cluster_id"                        = opentelekomcloud_cce_cluster_v3.this.id
      "tenant_id"                         = data.opentelekomcloud_identity_project_v3.current.id
      "coresTotal"                        = 40
      "expander"                          = "priority"
      "logLevel"                          = 4
      "maxEmptyBulkDeleteFlag"            = 11
      "maxNodesTotal"                     = 10
      "memoryTotal"                       = 120
      "scaleDownDelayAfterAdd"            = 5
      "scaleDownDelayAfterDelete"         = 5
      "scaleDownDelayAfterFailure"        = 3
      "scaleDownEnabled"                  = true
      "scaleDownUnneededTime"             = 5
      "scaleUpUnscheduledPodEnabled"      = true
      "scaleUpUtilizationEnabled"         = true
      "unremovableNodeRecheckTimeout"     = 5
      "scaleDownUtilizationThreshold"     = 0.75
      "maxEmptyBulkDeleteFlag"            = 1
      "skipNodesWithCustomControllerPods" = false
    }
  }
}
