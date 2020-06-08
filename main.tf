terraform {
    required_version = ">= 0.8.7"
}

provider "yandex" {
  token     = "${var.token}"
  cloud_id  = "${var.cloud_id}"
  folder_id = "${var.folder_id}"
  endpoint  = "api.cloud-preprod.yandex.net:443"
}

resource "yandex_vpc_network" "vpc" {
  name           = "data-svc-network" # TODO: change the name
}

resource "yandex_vpc_subnet" "subnet" {
 count="${length(var.yc_cidr_subnets)}"
 name = "${var.yc_project_name}-${var.yc_cluster_name}-subnet-${count.index}"
 zone = "${element(var.yc_availability_zones, count.index)}"
 network_id     = "${yandex_vpc_network.vpc.id}"
 v4_cidr_blocks = ["${element(var.yc_cidr_subnets, count.index)}"]
}


locals {
  subnet_ids = ["${yandex_vpc_subnet.subnet.*.id}"]
}

data "yandex_compute_image" "base_image" {
  family = "${var.yc_image_family}"
}

resource "yandex_compute_instance" "master" {

    count       = "${var.yc_kube_master_num}"

    name        = "k8s-master-${count.index}"
    hostname    = "k8s-master-${count.index}"
    description = "k8s-master-${count.index} of the ${var.yc_project_name} ${var.yc_cluster_name} cluster"
    zone = "${element(var.yc_availability_zones, count.index)}"

    resources {
      cores  = "${var.yc_kube_master_cpu}"
      memory = "${var.yc_kube_master_ram}"
    }

    boot_disk {
      initialize_params {
        image_id = "${data.yandex_compute_image.base_image.id}"
        #snapshot_id = "${data.yandex_compute_snapshot.kubeadm.id}"
        type_id = "network-nvme"
        size = "30"
      }
    }


    network_interface {
      subnet_id = "${element(local.subnet_ids, count.index)}"
      nat       = true
    }

    metadata {
      ssh-keys  = "centos:${file("${var.public_key_path}")}"
    ##  user-data = "${data.template_file.cloud-init.rendered}"
    }

}