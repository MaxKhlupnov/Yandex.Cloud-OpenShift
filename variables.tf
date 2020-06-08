variable "public_key_path" {
  description = "Path to public key file"
}

variable "token" {
  description = "Yandex Cloud security OAuth token"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created"
}

variable "cloud_id" {
  description = "Yandex Cloud ID where resources will be created"
}


//General Cluster Settings

variable "okd_project_name" {
  description = "Name of yc Cluster"
}
variable "okd_cluster_name" {
  description = "Name of yc Cluster"
}

variable "okd_image_family" {
  description = "family"
}


//yc VPC Variables


variable "okd_cidr_subnets" {
  description = "CIDR Blocks for private subnets in Availability Zones"
  type = "list"
}


//yc EC2 Settings


/*
* yc EC2 Settings
* The number should be divisable by the number of used
* yc Availability Zones without an remainder.
*/
variable "okd_kube_master_num" {
    description = "Number of Kubernetes Master Nodes"
}
variable "okd_kube_master_cpu" {
    description = "Number of Kubernetes Master Nodes"
}
variable "okd_kube_master_ram" {
    description = "Number of Kubernetes Master Nodes"
}

variable "okd_kube_worker_num" {
    description = "Number of Kubernetes Master Nodes"
}
variable "okd_kube_worker_cpu" {
    description = "Number of Kubernetes Master Nodes"
}
variable "okd_kube_worker_ram" {
    description = "Number of Kubernetes Master Nodes"
}

variable "okd_availability_zones" {
  type    = "list"
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}


/*
* yc ELB Settings
*
*/


variable "k8s_secure_api_port" {
    description = "Secure Port of K8S API Server"
}


variable "inventory_file" {
  description = "Where to store the generated inventory file"
}
