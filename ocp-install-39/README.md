# Installation of OpenShift Container Platform 3.9 into a single All-in-one VM

## Mar 2018 

These steps have been distilled from the below 3.9 documentation links. 

There is no 100% guarantee that the below instructions will work as-is in the target environment because the environment may be different to the one anticipated in these instructions.  Please always consult the following documentation if in doubt. 

# Official 3.9 Documentation Links

https://docs.openshift.com/container-platform/3.9/install_config/install/prerequisites.html

https://docs.openshift.com/container-platform/3.9/install_config/install/host_preparation.html

https://docs.openshift.com/container-platform/3.9/install_config/install/advanced_install.html

# Further reading

http://v1.uncontained.io/playbooks/installation/ 

# Create a VM with the following

1. RHEL 7.4 or 7.5
1. At least 8 GB of RAM, better 16 GB or more
1. 2 vCPU or more 
1. Attach an extra 30+GB disk for docker storage, e.g. /dev/sdb
1. One network interface only, with one static IP (which does not conflict with the following: 10.128.0.0/14 or 172.30.0.0/16)
1. The VM must have internet access 
1. A valid subscription of OpenShift, e.g. evaluation subs 
1. Console or remote VM access

## Set up DNS entries 

All the proper DNS entries must be configured.

Note that setting hostnames in /etc/hosts *will not work*. DNS entries are required. 

Select a domain name (FQDN) you control, e.g. openshift.example.com 

The hostname of the VM must be set to "master.<FQDN>" e.g. master.openshift.example.com  


## Set up the following DNS entries 

1. Wildcard entry:    *.apps.openshift.example.com              => $IP
1. A record:          master.openshift.example.com              => $IP

Log into the VM with ssh 

Set the hostname of the VM to master.$MY_FQDN 

Ensure the hostname resolves to the IP address of your network interface, using the following command 

```
host master.$MY_FQDN
```
(value of $IP) 

## Example

```
host master.openshift.example.com
192.168.10.10
```

Ensure each command succeeds before running the next command. 

Run all commands as root 

Ensure these variable are set (change to suit your environment!)  

```
export IP=ip-address-of-the-interface 
export SSH_USER=your-user
export MY_FQDN=your-FQDN
export MY_DEV=your-device-path
```

## Example

```
export IP=192.168.10.10
export SSH_USER=ec2-user 
export MY_FQDN=mydomain.com
export MY_DEV=/dev/sdb  
```

Ensure ssh works inside the VM using the VM's hostname by setting up the ssh keys (see Appendix II for help) 

```
ssh $SSH_USER@`hostname` id 
```
(should show the output of the "id" command)

## Register the server with Red Hat 

```
subscription-manager register --username=<user_name>
```

```
subscription-manager refresh
```

```
subscription-manager list --available  > /tmp/subs.txt
```
(find the 'pool id' in the /tmp/subs.txt file for 'OpenShift Container Platform' and use it in the next command)

```
subscription-manager attach --pool=<pool_id>
```

```
subscription-manager repos --disable="*"
```

```
yum-config-manager --disable \* 
```

```
subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.9-rpms" \
    --enable="rhel-7-fast-datapath-rpms"
```

Now, all the above 4 repos should be enabled only. Check with "yum repolist" command 


# Install the software

```
yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct && \
yum -y update && \
yum -y install atomic-openshift-utils && \
yum -y install atomic-openshift-excluder atomic-openshift-docker-excluder && \
atomic-openshift-excluder unexclude && \
yum -y install docker && \
echo "SOFTWARE INSTALLATION COMPLETED"
```


## Install docker 

```
yum -y install docker-1.12.6
```

```
docker version
```
(version should be 1.12, if not, something is wrong with the enabled repos) 

Configure docker by adding the option "--insecure-registry 172.30.0.0\/16" to /etc/sysconfig/docker

The following command will do that for you.

```
[ -f /tmp/docker.bak ] || ( sudo cp /etc/sysconfig/docker /tmp/docker.bak && \
sudo sed -i '/^OPTIONS=/s/--selinux-enabled /--selinux-enabled --insecure-registry 172.30.0.0\/16 /' /etc/sysconfig/docker )
```

If not already, set this variable to the device of the extra disk (be careful to use the right device, not the root device!) 

```
MY_DEV=<your device path> 
```

```
sudo cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=$MY_DEV
VG=docker-vg
EOF
```

Set up docker storage.

```
docker-storage-setup
```
(ensure no errors are shown!   Should see "Logical volume "docker-pool" created")  

# Check docker 

```
systemctl is-active docker
systemctl enable docker
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl restart docker
```

# Test docker with hello-world image 

```
docker  run  hello-world   
```
(The output must show "Hello from Docker!") 

# Ensure NetworkManager is enabled

```
systemctl  enable  NetworkManager
```

## Set up the ansible inventory file 

**Please see 'Appendix I' below on how to set up the ansible inventory file.**

### Check Ansible 

Test ansible in an adhoc way to ensure all nodes can be reached via ssh in a passwordless way.

```
ansible OSEv3 -m ping
```

### Install OpenShift by running ansible install playbook 

```
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
```

### If there is a problem...

Try to find a fix and re-run the above ansible-playbook command and add "-vvv" to see more verboose output.

```
ansible-playbook -vvv /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
```

It is also possible to uninstall everything, in order to try again. 

```
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml
```

### Verify OpenShift is working

```
oc get nodes 
```
(should return the master node, "ready")

### Set passwords / create new users

Once 'oc get nodes' is working, set your passwords.
```
htpasswd /etc/origin/openshift-passwd dev
htpasswd /etc/origin/openshift-passwd admin
```

### Set the cluster admin user

Once 'oc get nodes' is working designate the admin user to be a cluster admin

```
oadm policy add-cluster-role-to-user cluster-admin admin
```

### Log into the console 

Open the following URL in your browser and log in as users 'dev' or 'admin'.

```
https://master.$MY_FQDN/console/ 
```


# Appendix I 

Ensure these 2 variables are set (instructions above).

```
SSH_USER
MY_FQDN
```

Run one of the following commands (curl or wget) to create the ansible inventory file. Check the content of the /etc/ansible/hosts file look like the below example. 

The username and the domain names should be set correctly with the values of the above 2 variables. 

```
curl -s https://raw.githubusercontent.com/sjbylo/misc/master/ocp-install-36/create-hosts | bash 
```

```
wget -q -O - https://raw.githubusercontent.com/sjbylo/misc/master/ocp-install-36/create-hosts  | bash
```

Ensure the inventory file looks like the following.  Note, do not use the below but instead use the curl/bash command above.
Both the username (\$SSH_USER) and the domain (\$MY_FQDN) have been substituted.

```
[OSEv3:children]
masters
etcd
nodes

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
ansible_user=ec2-user
# Uninstall playbook needed the following 
#ansible_ssh_user=ec2-user
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
openshift_master_default_subdomain=apps.example.com

# default project node selector
osm_default_node_selector='env=dev'

# Router selector (optional)
openshift_hosted_router_selector='env=dev'
openshift_hosted_router_replicas=1

# Registry selector (optional)
openshift_registry_selector='env=dev'

# Configure metricsPublicURL in the master config for cluster metrics
#openshift_master_metrics_public_url=https://hawkular-metrics.example.com

# Configure loggingPublicURL in the master config for aggregate logging
#openshift_master_logging_public_url=https://kibana.example.com

# host group for masters
[masters]
master.example.com

# host group for etcd
[etcd]
master.example.com

# host group for nodes, includes region info
[nodes]
master.example.com   openshift_public_hostname="master.example.com"  openshift_schedulable=true openshift_node_labels="{'name': 'master', 'region': 'infra', 'env': 'dev'}"
```

# Appendix II

See: http://www.linuxproblem.org/art_9.html

Copy your local private key to the VM 

```
scp ~/.ssh/id_rsa  $SSH_USER@$IP:.ssh/
ssh $SSH_USER@$IP   # log into the VM
sudo -i 
cp /home/$SSH_USER/.ssh/id_rsa /root/.ssh/ && sudo chmod 600 /root/.ssh/id_rsa
ssh $SSH_USER@`hostname` id   # should work without a password 
```

# Appendix III

If there are 2 network interfaces  

Note: if the VM has more than one network interface, add the following ansible variable to /etc/ansible/hosts for the master entry (bottom of file) 
```
  openshift_hostname="<ip-of-private-net-interface>"
```

This variable overrides the internal cluster host name for the system. Use this when the system’s default IP address does not resolve to the system host name.

