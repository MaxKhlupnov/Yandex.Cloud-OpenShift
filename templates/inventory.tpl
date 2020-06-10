# Ansible inventory file template, see https://docs.okd.io/3.11/install/configuring_inventory_file.html 
# Create an OSEv3 group that contains the masters, nodes, and etcd groups
[OSEv3:children]
masters
nodes
etcd
lb

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
ansible_ssh_user=root
openshift_deployment_type=origin

# uncomment the following to enable htpasswd authentication; defaults to AllowAllPasswordIdentityProvider
#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider'}]

# Native high availbility cluster method with Yandex Cloud load balancer.
# If no lb group is defined installer assumes that a load balancer has
# been preconfigured. For installation the value of
# openshift_master_cluster_hostname must resolve to the load balancer
# or to one or all of the masters defined in the inventory if no load
# balancer is present.
openshift_master_cluster_method=native
openshift_master_cluster_hostname=openshift-internal.example.com
openshift_master_cluster_public_hostname=openshift-cluster.example.com

# apply updated node defaults
openshift_node_groups=[{'name': 'node-config-all-in-one', 'labels': ['node-role.kubernetes.io/master=true', 'node-role.kubernetes.io/infra=true', 'node-role.kubernetes.io/compute=true'], 'edits': [{ 'key': 'kubeletArguments.pods-per-core','value': ['20']}]}]

# host group for masters
[masters]
${list_master}

# host group for etcd
[etcd]
${list_etcd}

# Specify load balancer host
[lb]
lb.example.com


# host group for nodes, includes region info
[nodes]
${connection_strings_master}
${connection_strings_node}
#master.example.com openshift_node_group_name='node-config-master'
#node1.example.com openshift_node_group_name='node-config-compute'
#node2.example.com openshift_node_group_name='node-config-compute'
#infra-node1.example.com openshift_node_group_name='node-config-infra'
#infra-node2.example.com openshift_node_group_name='node-config-infra'