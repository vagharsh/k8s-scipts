#!/bin/bash

scriptVersion=1.3
scriptName="Kubernetes Master node Initialization script"
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

# Setup certificates

openssl genrsa -out /tmp/ca.key 2048
openssl req -x509 -new -nodes -key /tmp/ca.key -subj "/CN=${KUBE_ADVERTISE_IP}" -days 3650 -out /tmp/ca.crt
mkdir -p /etc/kubernetes/pki/
cp -f /tmp/ca.crt /etc/kubernetes/pki/
cp -f /tmp/ca.key /etc/kubernetes/pki/
cp -f /tmp/ca.crt /etc/pki/ca-trust/source/anchors/
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