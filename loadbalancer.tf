# Load Balancing For HA Applications via Yandex Load Balancer
# see https://github.com/redhat-cop/openshift-playbooks/blob/master/playbooks/installation/load_balancing.adoc

locals {
  //masters = [yandex_compute_instance.master.*.id, yandex_compute_instance.master.*.network_interface.0.ip_address]
  subnet_mapping = [for i, master in yandex_compute_instance.master : { master_ip : master.network_interface.0.ip_address, subnet_id : master.network_interface.0 }]
}

 //  Use `subnet_mapping` to attach EIPs
  
/*resource "yandex_lb_target_group" "okd_master_target" {
  name      = "lbgrp-mgmt-8443"
  for_each = {
    for i, master in yandex_compute_instance.master: 
            { 
              ip_address : master.network_interface.0.ip_address, 
              subnet_id : master.network_interface.subnet_id
            } => i
  }
}*/

resource "yandex_lb_target_group" "okd_master_target" {
  name      = "lb-grp-mgmt-8443"
  for_each = {
    for ic in range(var.okd_kube_master_num): "${ic}" => ic
  }
  target {
    subnet_id = element(yandex_compute_instance.master, each.key).network_interface.0.subnet_id
    address   = element(yandex_compute_instance.master,each.key).network_interface.0.ip_address
  }
}





 /* for_each = { for m in local.subnet_mapping: m.master_ip => m } 
     
  depends_on = [
    yandex_compute_instance.master
  ]
  */

/*
resource "yandex_lb_network_load_balancer" "foo" {
  name = "my-network-load-balancer"
}*/