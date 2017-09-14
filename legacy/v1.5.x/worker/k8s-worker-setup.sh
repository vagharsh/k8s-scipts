#!/bin/bash

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0

systemctl disable firewalld && systemctl stop firewalld 
systemctl start docker

# 1.5.4 is the latest previous version in the repo.  Because of messed up 
# versioning in the 1.5 release, kubeadm is no longer indexed in the repos
# so we have to refer to the RPM directly.
sudo yum -y install \
  yum-versionlock \
  kubectl-1.5.4-0 \
  kubelet-1.5.4-0 \
  kubernetes-cni-0.3.0.1-0.07a8a2 \
  http://yum.kubernetes.io/pool/082436e6e6cad1852864438b8f98ee6fa3b86b597554720b631876db39b8ef04-kubeadm-1.6.0-0.alpha.0.2074.a092d8e0f95f52.x86_64.rpm 

# Lock the version of these packages so that we don't upgrade them accidentally.
sudo yum versionlock add kubectl kubelet kubernetes-cni kubeadm

# Enable and start up docker and the kubelet

systemctl disable firewalld && systemctl stop firewalld 
systemctl start docker
systemctl enable kubelet && systemctl start kubelet

echo "net.bridge.bridge-nf-call-ip6tables = 1" > /etc/sysctl.d/k8s.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/k8s.conf