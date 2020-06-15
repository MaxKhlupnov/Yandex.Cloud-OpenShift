# Load Balancing For HA Applications via Yandex Load Balancer
# see https://github.com/redhat-cop/openshift-playbooks/blob/master/playbooks/installation/load_balancing.adoc

locals {
  master_mapping = flatten([for i, master in yandex_compute_instance.master : 
          {
               ip_address = master.network_interface.0.ip_address, 
               subnet_id = master.network_interface.0.subnet_id 
          }])
  
  infra_mapping = flatten([for i, infra in yandex_compute_instance.infra : 
        {
              ip_address = infra.network_interface.0.ip_address, 
              subnet_id = infra.network_interface.0.subnet_id 
        }])
}

################################################################
# PUBLIC target group and load balancer for MASTER nodes
################################################################
resource "yandex_lb_target_group" "okd_master_public_target" {
 name      = "lb-target-group-mgmt-public"
 dynamic "target" {
    for_each = local.master_mapping
    content{
      address = target.value.ip_address
      subnet_id = target.value.subnet_id 
  
    }
 }
}

resource "yandex_lb_network_load_balancer" "okd_master_public_lb" {
  name = "mgmt-public-load-balancer"
  type = "external"

  listener {
    name = "listener-mgmt-8443"
    port = 8443
    protocol = "tcp"
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.okd_master_public_target.id

    healthcheck {
      name = "tcp-check"
      http_options {
        port = 8443
        path = "/"
      }
    }
  }
}  


################################################################
# INTERNAL target group and load balancer for MASTER nodes
################################################################
resource "yandex_lb_target_group" "okd_master_internal_target" {
 name      = "lb-target-group-mgmt-internal"
 dynamic "target" {
    for_each = local.master_mapping
    content{
      address = target.value.ip_address
      subnet_id = target.value.subnet_id 
  
    }
 }
}

resource "yandex_lb_network_load_balancer" "okd_master_internal_lb" {
  name = "mgmt-intgernal-load-balancer"
  type = "internal"

  listener {
    name = "listener-mgmt-8443"
    port = 8443
    protocol = "tcp"
    internal_address_spec {
      subnet_id = element(yandex_vpc_subnet.subnet, 0).id # Create lb in first subnet by default
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.okd_master_internal_target.id

    healthcheck {
      name = "tcp-check"
      http_options {
        port = 8443
        path = "/"
      }
    }
  }
}  

################################################################
# INTERNAL target group and load balancer for INFRA nodes
################################################################
resource "yandex_lb_target_group" "okd_infra_internal_target" {
 name      = "lb-target-group-infra-internal"
 dynamic "target" {
    for_each = local.infra_mapping
    content{
      address = target.value.ip_address
      subnet_id = target.value.subnet_id 
  
    }
 }
}

resource "yandex_lb_network_load_balancer" "okd_infra_internal_lb" {
  name = "infra-intgernal-load-balancer"
  type = "internal"

  listener {
    name = "listener-infra-80"
    port = 80
    protocol = "tcp"
    internal_address_spec {
      subnet_id = element(yandex_vpc_subnet.subnet, 0).id # Create lb in first subnet by default
      ip_version = "ipv4"
    }
  }

    listener {
    name = "listener-infra-443"
    port = 443
    protocol = "tcp"
    internal_address_spec {
      subnet_id = element(yandex_vpc_subnet.subnet, 0).id # Create lb in first subnet by default
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.okd_infra_internal_target.id

    healthcheck {
      name = "tcp-check"
      http_options {
        port = 8443
        path = "/"
      }
    }
  }
}  