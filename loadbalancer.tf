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
 name      = "lb-grp-mgmt-8443"
 dynamic "target" {
    for_each = local.master_mapping
    content{
      address = target.value.ip_address
      subnet_id = target.value.subnet_id 
  
    }
 }
}
 
  