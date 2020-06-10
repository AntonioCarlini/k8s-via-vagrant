#!/bin/bash

# $1: master host name

# Join worker nodes to the Kubernetes cluster
apt-get  install --no-install-recommends -y sshpass >/dev/null 2>&1

# Copy the cluster join script from the master and invoke it
sshpass -p "kubeadmin" scp -o StrictHostKeyChecking=no "$1":/k8s-cluster-join-command.sh /k8s-cluster-join-command.sh
bash /k8s-cluster-join-command.sh >/dev/null 2>&1
