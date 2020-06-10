# Load Balancing For HA Applications via Yandex Load Balancer
# see https://github.com/redhat-cop/openshift-playbooks/blob/master/playbooks/installation/load_balancing.adoc

resource "yandex_lb_target_group" "okd_master_target" {
  count       = var.okd_kube_master_num
  name      = "lb-grp-mgmt-${count.index}"  

  target {
    subnet_id = element(yandex_compute_instance.master, count.index).network_interface.0.subnet_id
    address   = element(yandex_compute_instance.master,count.index).network_interface.0.ip_address
  }

}


