/*
* Create Inventory File
*
*/
data "template_file" "inventory" {
    template = "${file("${path.module}/templates/inventory.tpl")}"
    vars = {
        #public_ip_address_bastion = "${join("\n",formatlist("bastion ansible_host=%s" , okd_instance.bastion-server.*.public_ip))}"
        connection_strings_master = "${join("\n",formatlist("%s openshift_node_group_name='node-config-master'",yandex_compute_instance.master.*.fqdn))}"
        connection_strings_node = "${join("\n", formatlist("%s openshift_node_group_name='node-config-compute'", yandex_compute_instance.worker.*.fqdn))}"
        list_master = "${join("\n",  yandex_compute_instance.master.*.fqdn)}"
        list_node = "${join("\n",yandex_compute_instance.worker.*.fqdn)}"
        list_etcd = "${join("\n",yandex_compute_instance.master.*.fqdn)}"
    }

}

resource "local_file" "inventory" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory.cfg"
}
