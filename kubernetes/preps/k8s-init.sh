#!/bin/bash

scriptVersion=1.3
scriptName="Kubernetes Single Master node Initialization script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

cat <<EOF
**********************************************************
Initializing Kubeadm, it might take a minute or so ......
**********************************************************
EOF

if [ ${#KUBE_ADVERTISE_IP} -le 0 ]; then
    KUBE_ADVERTISE_IP=$(ip addr show ${DEFAULT_NIC} | grep -Po 'inet \K[\d.]+')
fi

mkdir -p /etc/kubernetes/pki/
cp -rf certificates/* /etc/kubernetes/pki/
chmod 600 /etc/kubernetes/pki/*.key /etc/kubernetes/pki/*.pub
chmod 644 /etc/kubernetes/pki/*.crt

cp -f certificates/ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

if [ ${#KUBE_VERSION} -le 0 ]; then
    kubeadm init \
        --pod-network-cidr=10.244.0.0/16 \
        --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
        >> /tmp/kubeadminit.txt
else
    kubeadm init \
        --kubernetes-version=$KUBE_VERSION \
        --pod-network-cidr=10.244.0.0/16 \
        --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
        >> /tmp/kubeadminit.txt
fi

mkdir -p ~/.kube/
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

cp "/etc/kubernetes/admin.conf" /tmp/
chmod 666 "/tmp/admin.conf"