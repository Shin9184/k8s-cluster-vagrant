#!/usr/bin/bash

# swapoff -a to disable swapping
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

# set SELinux 
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sestatus

# disable firewalld and NetworkManager
systemctl stop firewalld && systemctl disable firewalld
systemctl stop NetworkManager && systemctl disable NetworkManager

# enabling iptables kernel options
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo modprobe br_netfilter
sysctl --system

# kubernetes repository
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# add hosts
cat << EOF >> /etc/hosts
192.168.1.10 k8s-master
192.168.1.11 k8s-worker1
192.168.1.12 k8s-worker2
EOF

# config DNS
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8 #Google DNS
EOF

# ssh password Authentication no to yes
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd