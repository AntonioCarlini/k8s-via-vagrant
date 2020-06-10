#!/usr/bin/env bash

# $1: The IP address of the kubernetes master
# $2: The IP network spec

# Initialize Kubernetes
kubeadm init --apiserver-advertise-address="$1" --pod-network-cidr="$2" >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml"

# Generate Cluster join command
kubeadm token create --print-join-command > /k8s-cluster-join-command.sh
