#Global Vars
yc_oauth_token = "<your_value>"
yc_cloud_id    = "<your_value>"
yc_folder_id   = "<your_value>"
public_key_path ="<your_ssh_public_key_file_path>"

okd_project_name = "openshift"
okd_cluster_name = "okd-dev-test"
okd_image_family = "centos-7"

#VPC Vars
okd_cidr_subnets = ["10.250.192.0/24","10.250.193.0/24","10.250.194.0/24"]

# Public cluster master lb DNS-name
openshift_master_cluster_public_hostname = "my-openshift.foo.com"

#Bastion VM instance
okd_bastion_cpu = "2"
okd_bastion_ram = "4"

#Kubernetes Cluster

okd_kube_master_num = 3
okd_kube_master_cpu = "2"
okd_kube_master_ram = "4"

okd_kube_infra_num = 3
okd_kube_infra_cpu = "2"
okd_kube_infra_ram = "4"

okd_kube_worker_num = 3
okd_kube_worker_cpu = "2"
okd_kube_worker_ram = "4"

#Settings yc ELB

#k8s_secure_api_port = 6443
#kube_insecure_apiserver_address = "0.0.0.0"
#inventory_file = "../inventory/yc/hosts.ini"
