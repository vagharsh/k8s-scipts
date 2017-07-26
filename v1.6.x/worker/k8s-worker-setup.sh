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

yum install -y yum-versionlock kubelet kubeadm kubectl kubernetes-cni

# Lock the version of these packages so that we don't upgrade them accidentally.
sudo yum versionlock add kubectl kubelet kubernetes-cni kubeadm

sudo setenforce 0

systemctl disable firewalld && systemctl disable iptables-services
systemctl stop firewalld && systemctl stop iptables-services

systemctl start docker
systemctl enable kubelet && systemctl daemon-reload && systemctl start kubelet

echo "net.bridge.bridge-nf-call-ip6tables = 1" > /etc/sysctl.d/k8s.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/k8s.conf
