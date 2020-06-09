resource "yandex_compute_instance" "master" {

    count       = var.okd_kube_master_num
    platform_id = "standard-v2" // Intel Cascade Lake
    name        = "k8s-master-${count.index}"
    hostname    = "k8s-master-${count.index}"
    description = "k8s-master-${count.index} of the ${var.okd_project_name} ${var.okd_cluster_name} cluster"
    zone = element(var.okd_availability_zones, count.index)

    resources {
      cores  = var.okd_kube_master_cpu
      memory = var.okd_kube_master_ram
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.base_image.id
        #snapshot_id = "${data.yandex_compute_snapshot.kubeadm.id}"
        # type_id = "network-nvme"
        size = "30"
      }
    }


    network_interface {
      subnet_id = element(yandex_vpc_subnet.subnet, count.index).id
      nat       = true
    }

    metadata = {
      ssh-keys  = "centos:${file("${var.public_key_path}")}"
    ##  user-data = "${data.template_file.cloud-init.rendered}"
    }

}