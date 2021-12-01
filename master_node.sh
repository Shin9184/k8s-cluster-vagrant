#!/usr/bin/bash

# init kubernetes for kubeadm
kubeadm init --token 123456.1234567890123456 \
            --token-ttl 0 \
            --pod-network-cidr=10.244.0.0/16 \
            --apiserver-advertise-address=192.168.1.10

# master node config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Kubernetes network interface config - calico
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# set bash-completion
yum install bash-completion -y

echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc