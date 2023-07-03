#!/usr/bin/bash

# init kubernetes for kubeadm
sudo kubeadm init --token 123456.1234567890123456 \
            --token-ttl 0 \
            --apiserver-advertise-address=192.168.1.10 \
            --pod-network-cidr=10.244.10.0/24
 
# master node config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Kubernetes network interface config - calico
##sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
##sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml -O
##sudo curl https://docs.tigera.io/calico/latest/manifests/calico.yaml -O

# Backup the original file
#sudo cp custom-resources.yaml custom-resources.yaml.backup
##sudo cp calico.yaml calico.yaml.backup

#sudo sed -i 's/cidr:  192.168.0.0\/16/cidr: 10.224.0.0\/16/' custom-resources.yaml
#sudo sed -i 's/cidr:  192.168.0.0\/16/cidr: 10.224.0.0\/16/' calico.yaml
#sudo kubectl create -f custom-resources.yaml
#sudo kubectl create -f calico.yaml

sudo wget https://raw.githubusercontent.com/flannel-io/flannel/v0.20.0/Documentation/kube-flannel.yml
sudo sed -i -e 's?10.244.0.0/16?10.244.10.0/24?g' kube-flannel.yml
kubectl apply -f kube-flannel.yml


# set bash-completion
sudo yum install bash-completion -y

echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc