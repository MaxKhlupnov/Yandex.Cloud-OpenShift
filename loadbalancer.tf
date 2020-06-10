# Load Balancing For HA Applications via Yandex Load Balancer
# see https://github.com/redhat-cop/openshift-playbooks/blob/master/playbooks/installation/load_balancing.adoc

locals {
  master_mapping = flatten([for i, master in yandex_compute_instance.master : 
          {
               ip_address = master.network_interface.0.ip_address, 
               subnet_id = master.network_interface.0.subnet_id 
          }])
}

resource "yandex_lb_target_group" "okd_master_target" {
 name      = "lb-target-group-mgmt"
 dynamic "target" {
    for_each = local.master_mapping
    content{
      address = target.value.ip_address
      subnet_id = target.value.subnet_id 
  
    }
 }
}
 
resource "yandex_lb_network_load_balancer" "okd_master_lb" {
  name = "mgmt-load-balancer"

  listener {
    name = "listener-mgmt-8443"
    port = 8443
    protocol = "tcp"
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.okd_master_target.id

    healthcheck {
      name = "tcp-check"
      http_options {
        port = 8443
        path = "/"
      }
    }
  }
}  