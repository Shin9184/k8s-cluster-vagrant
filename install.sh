#!/usr/bin/bash

# install packages for docker
yum install -y yum-utils device-mapper-persistent-data lvm2

# docker repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# yum update and install docker
yum update -y && yum install -y docker-ce

mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl enable docker
systemctl daemon-reload
systemctl restart docker

# install kubernetes
yum install -y --disableexcludes=kubernetes kubeadm kubectl kubelet
systemctl enable --now kubelet