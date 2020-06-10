#!/usr/bin/env bash

# Put all nodes into the hosts file
cat /home/vagrant/k8s-hosts.txt >> /etc/hosts

# Add all the new keys in one go
apt-get update -y
apt-get install --no-install-recommends -y ca-certificates curl software-properties-common apt-transport-https
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# Add the kubernetes sources list into the sources.list directory
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Install docker (see https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)
apt-get update -y
apt-get install --no-install-recommends -y docker-ce

# Allow vagrant account use of docker
usermod -aG docker vagrant

# Enable docker service
systemctl enable docker >/dev/null 2>&1
systemctl start docker

# Install kubernetes (see https://www.linuxtechi.com/install-configure-kubernetes-ubuntu-18-04-ubuntu-18-10/)

# Add sysctl settings
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/kubernetes.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/kubernetes.conf
sysctl --system > /dev/null 2>&1

# Disable swap (as required by kubernetes)
sed -i '/swap/d' /etc/fstab
swapoff -a

# Install Kubernetes
apt-get install --no-install-recommends -y kubelet kubeadm kubectl

# Start and Enable kubelet service
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

# Enable ssh password authentication
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Set Root password
echo -e "kubeadmin\nkubeadmin" | passwd root

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc
