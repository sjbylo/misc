# Installation of OpenShift Container Platform 3.5 into a single All-in-one VM

## May 2017 

These steps have been distilled from the below 3.5 documentation links. 

There is no 100% guarantee that the below instructions will work as-is in the target environment because the environment may be different to the one anticipated in these instructions.  Please always consult the following documentation if in doubt. 

# Documentation 

https://docs.openshift.com/container-platform/3.5/install_config/install/prerequisites.html

https://docs.openshift.com/container-platform/3.5/install_config/install/host_preparation.html

https://docs.openshift.com/container-platform/3.5/install_config/install/advanced_install.html


# Create a VM with the following

1. RHEL 7.3 
2. At least 8 GB of RAM, better 16 GB or more
3. 2 vCPU 
4. Attach an extra disk for docker storage, e.g. /dev/sdb
5. One network interface with a static IP  
6. The VM must have internet access 
7. A valid subscription of OpenShift, e.g. evaluation subs 
8. Ensure ssh can be used to log into the VM without a password, and also from the VM itself (needed for ansible) 


## Set up DNS entries 

#DNS must be configured#

Note that setting hostnames in /etc/hosts *will not work* 

Select a domain name (FQDN) you control, e.g. openshift.example.com 

The hostname of the VM must be set to "master.<FQDN>" e.g. master.openshift.example.com 

# Set up the following DNS entries 

1) Wildcard entry:    *.apps.openshift.example.com              => $IP
2) A record:          master.openshift.example.com              => $IP
3) A record:          hawkular-metrics.openshift.example.com    => $IP

# Log into the VM with ssh 

# Set the hostname of the VM to master.$MY_FQDN 

# Ensure the hostname resolves to the IP address of your network interface, using the following command 

host master.$MY_FQDN
(value of $IP) 

# Example
host master.openshift.example.com
192.168.10.10

# Ensure each command succeeds before running the next command. 

# Run all commands as root 

# Ensure these variable are set (change to suit your environment!)  

IP=ip-address-of-the-interface 
SSH_USER=your-user
MY_FQDN=your-FQDN
MY_DEV=your-device-path

# Example

IP=192.168.10.10
SSH_USER=ec2-user 
MY_FQDN=mydomain.com
MY_DEV=/dev/sdb  

# Ensure ssh works inside the VM using the VM's hostname by setting up the ssh keys (see Appendix 2 for help) 

ssh $SSH_USER@`hostname` id 
(should show the output of the "id" command)

## Register the server with Red Hat 

subscription-manager register --username=<user_name> --password=<password>

subscription-manager list --available  > /tmp/list
(find the 'pool id' in the /tmp/list file for 'OpenShift Container Platform' and use it in the next command)

subscription-manager attach --pool=<pool_id>

subscription-manager repos --disable="*"

yum-config-manager --disable \* 

subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.5-rpms" \
    --enable="rhel-7-fast-datapath-rpms"

# Now, all the above 4 repos should be enabled only. Check with "yum repolist" command 


## Install the software

yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion && \
yum -y update && \
yum -y install atomic-openshift-utils && \
yum -y install atomic-openshift-excluder atomic-openshift-docker-excluder && \
atomic-openshift-excluder unexclude


## Install docker 

yum install docker

docker version
(version should be 1.12, if not, something is wrong with the enabled repos) 

# Configure docker by adding the option "--insecure-registry 172.30.0.0\/16" to /etc/sysconfig/docker
# The following command will do that for you 

[ -f /tmp/docker.bak ] || ( sudo cp /etc/sysconfig/docker /tmp/docker.bak && \
sudo sed -i '/^OPTIONS=/s/selinux-enabled -/selinux-enabled --insecure-registry 172.30.0.0\/16 -/' /etc/sysconfig/docker )

# If not already, set this variable to the device of the extra disk (be careful to use the right device, not the root device!) 
MY_DEV=<your device path> 

cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=$MY_DEV
VG=docker-vg
EOF

docker-storage-setup
(ensure no errors are shown!   Should see "Logical volume "docker-pool" created")  

# Check docker 

systemctl is-active docker
systemctl enable docker
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl restart docker

# test docker with hello-world image 

docker  run  hello-world   
(Must show "Hello from Docker!") 

# Ensure NetworkManager is enabled

systemctl  enable  NetworkManager

## Set up the ansible hosts file 

<< The Appendix describes how to do this >> 

# Install OpenShift by running ansible install playbook 

ansible-playbook -e enable_excluders=false /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
#ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml

# Create the cluster admin for user admin

oadm policy add-cluster-role-to-user cluster-admin admin

# Set passwords / create new users

htpasswd /etc/origin/openshift-passwd dev
htpasswd /etc/origin/openshift-passwd admin

# Verify OpenShift is working

oc get nodes 
(should return the master node, "ready")

# Log into the console at https://master.$MY_FQDN/console/ 



Appendix I 

# Ensure these 2 variables are set (instructions above) and run the below command, starting with cat and ending with END. This will create the file /etc/ansible/hosts with the correct content.  

SSH_USER
MY_FQDN

cat > /etc/ansible/hosts <<END
# Create an OSEv3 group that contains the master, nodes, etcd, and lb groups.
[OSEv3:children]
masters
etcd
nodes

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
ansible_user=$SSH_USER
# Uninstall playbook needed the following 
#ansible_ssh_user=$SSH_USER
ansible_become=true
deployment_type=openshift-enterprise
debug_level=4
openshift_clock_enabled=true

openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/openshift-passwd'}]

# dev and admin users
openshift_master_htpasswd_users={'dev': 'your-htpasswd-hash-here', 'admin': 'your-htpasswd-hash-here'}

osm_default_node_selector='env=dev'
openshift_hosted_metrics_deploy=true
#openshift_hosted_logging_deploy=true

# default subdomain to use for exposed routes
openshift_master_default_subdomain=apps.$MY_FQDN

# default project node selector
osm_default_node_selector='env=dev'

# Router selector (optional)
openshift_hosted_router_selector='env=dev'
openshift_hosted_router_replicas=1

# Registry selector (optional)
openshift_registry_selector='env=dev'

# Configure metricsPublicURL in the master config for cluster metrics
openshift_master_metrics_public_url=https://hawkular-metrics.$MY_FQDN

# Configure loggingPublicURL in the master config for aggregate logging
#openshift_master_logging_public_url=https://kibana.$MY_FQDN

# host group for masters
[masters]
master.$MY_FQDN

# host group for etcd
[etcd]
master.$MY_FQDN

# host group for nodes, includes region info
[nodes]
master.$MY_FQDN   openshift_public_hostname="master.$MY_FQDN"  openshift_schedulable=true openshift_node_labels="{'name': 'master', 'region': 'infra', 'env': 'dev'}"
END


Appendix II

# Copy an existing private key to the VM 

scp ~/.ssh/id_rsa  $MY_USER@$IP:.ssh/
sudo cp ~ec2-user/.ssh/id_rsa /root/.ssh/ && sudo chmod 600 /root/.ssh/id_rsa
sudo -i 
ssh ec2-user@localhost id   # should work without a password 


Appendix III

# If there are 2 network interfaces  

Note: if the VM has more than one network interface, add the following ansible variable to /etc/ansible/hosts for the master entry (bottom of file) 
  openshift_hostname="<ip-of-private-net-interface>"
This variable overrides the internal cluster host name for the system. Use this when the system’s default IP address does not resolve to the system host name



