# Load Balancing For HA Applications via Yandex Load Balancer
# see https://github.com/redhat-cop/openshift-playbooks/blob/master/playbooks/installation/load_balancing.adoc
resource "yandex_lb_target_group" "okd_master_target" {
 count       = var.okd_kube_master_num
  name      = "lbgrp-mgmt-8443-${count.index}"
  region_id = element(var.okd_availability_zones, count.index)

  target {
    subnet_id = element(yandex_vpc_subnet.subnet, count.index).id
    address   = element(yandex_compute_instance.master,count.index).network_interface.0.ip_address
  }
}
/*
resource "yandex_lb_network_load_balancer" "foo" {
  name = "my-network-load-balancer"
}*/