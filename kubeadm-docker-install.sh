#!/bin/bash
#
# Script to install Docker and Kubeadm in Ubuntu 18.04
# 
# Written by Juan Manuel Rey <juanmanuel.reyportal@gmail.com>
# Based on Kubernetes official doc
#


echo "Installing Docker..."

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install -y docker-ce=5:18.09.9~3-0~ubuntu-bionic docker-ce-cli containerd.io

echo "Configuring Docker..."

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Installing Kubernetes components..."

sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add 
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# https://blog.jreypo.io/containers/microsoft/azure/cloud/cloud-native/devops/deploying-a-kubernetes-cluster-in-azure-using-kubeadm/
# https://www.scaleway.com/en/docs/deploy-kubernetes-cluster-kubeadm-cloud-controller-manager/
# https://cloudyuga.guru/blog/cloud-controller-manager
