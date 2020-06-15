/*
* Create Inventory File
*
*/
data "template_file" "inventory" {
    template = "${file("${path.module}/templates/inventory.tpl")}"
    vars = {
        #public_ip_address_bastion = "${join("\n",formatlist("bastion ansible_host=%s" , okd_instance.bastion-server.*.public_ip))}"
        connection_strings_master = "${join("\n",formatlist("%s openshift_node_group_name='node-config-master'",yandex_compute_instance.master.*.fqdn))}"
        connection_strings_worker = "${join("\n", formatlist("%s openshift_node_group_name='node-config-compute'", yandex_compute_instance.worker.*.fqdn))}"
        connection_strings_infra = "${join("\n", formatlist("%s openshift_node_group_name='node-config-infra'", yandex_compute_instance.infra.*.fqdn))}"
        list_master = "${join("\n",  yandex_compute_instance.master.*.fqdn)}"
        list_node = "${join("\n",yandex_compute_instance.worker.*.fqdn)}"
        list_etcd = "${join("\n",yandex_compute_instance.master.*.fqdn)}"
        openshift_master_cluster_public_hostname = var.openshift_master_cluster_public_hostname
        openshift_master_cluster_hostname = yandex_lb_network_load_balancer.okd_master_internal_lb.name //TODO: cahnge to ip
    }

}

resource "local_file" "inventory" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory.cfg"
}
