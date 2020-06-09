terraform {
    required_version = ">= 0.12.24"
}

provider "yandex" {
  version = "~> 0.40"
  token     = var.yc_oauth_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
#  endpoint  = "api.cloud-preprod.yandex.net:443"
}

resource "yandex_vpc_network" "vpc" {
  name           = "openshift-vpc" 
}

resource "yandex_vpc_subnet" "subnet" {
 count= length(var.okd_cidr_subnets)
 name = "${var.okd_project_name}-${var.okd_cluster_name}-subnet-${count.index}"
 zone = element(var.okd_availability_zones, count.index)
 network_id     = yandex_vpc_network.vpc.id
 v4_cidr_blocks = [element(var.okd_cidr_subnets, count.index)]
}


/*locals {
  subnet_ids = ["${yandex_vpc_subnet.subnet.*.id}"]
}*/



data "yandex_compute_image" "base_image" {
  family = "${var.okd_image_family}"
}





/*
* Create Inventory File
*

data "template_file" "inventory" {
    template = "${file("${path.module}/templates/inventory.tpl")}"
    vars = {
        #public_ip_address_bastion = "${join("\n",formatlist("bastion ansible_host=%s" , okd_instance.bastion-server.*.public_ip))}"
        connection_strings_master = "${join("\n",formatlist("%s openshift_node_group_name='node-config-master'",yandex_compute_instance.master.*.name))}"
        connection_strings_node = "${join("\n", formatlist("%s openshift_node_group_name='node-config-compute'", yandex_compute_instance.worker.*.name))}"
        list_master = "${join("\n",yandex_compute_instance.master.*.name)}"
        list_node = "${join("\n",yandex_compute_instance.worker.*.name)}"
        list_etcd = "${join("\n",yandex_compute_instance.master.*.name)}"
    }

}*/