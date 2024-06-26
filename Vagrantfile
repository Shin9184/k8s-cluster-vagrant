# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  ### Master Node ####

  config.vm.define "k8s-master" do |master|
    master.vm.box = "generic/centos8"
    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
      vb.cpus = 2
      vb.memory = 3072
      vb.customize ["modifyvm", :id, "--groups", "/k8s-cluster"]
    end
    master.vm.host_name = "k8s-master"
    master.vm.network "private_network", ip: "192.168.1.10"
    master.vm.network "forwarded_port", guest: 22, host: 10030, auto_correct: true, id: "ssh"
    master.vm.synced_folder ".", "/vagrant", disabled: true
    master.vm.provision "shell", path: "config.sh"
    master.vm.provision "shell", path: "install.sh"
    master.vm.provision "shell", path: "master_node.sh"
  end

  ### Worker node ###

  (1..2).each do |i|
    config.vm.define "k8s-worker#{i}" do |worker|
      worker.vm.box = "generic/centos8"
      worker.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-worker#{i}"
        vb.cpus = 1
        vb.memory = 2048
        vb.customize ["modifyvm", :id, "--groups", "/k8s-cluster"]
      end
      worker.vm.host_name = "k8s-worker#{i}"
      worker.vm.network "private_network", ip: "192.168.1.1#{i}"
      worker.vm.network "forwarded_port", guest: 22, host: "1003#{i}", auto_correct: true, id: "ssh"
      worker.vm.synced_folder ".", "/vagrant", disabled: true
      worker.vm.provision "shell", path: "config.sh"
      worker.vm.provision "shell", path: "install.sh"
      worker.vm.provision "shell", path: "worker_node.sh"
    end
  end

end