#!/bin/bash

scriptVersion=1.0
scriptName="Kubernetes Master node Initialization script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

cat <<EOF
**********************************************************
Initializing Kubeadm, it might take a minute or so ......
**********************************************************
EOF

if [ ${#KUBE_ADVERTISE_IP} -le 0 ]; then
    kubeadm init --kubernetes-version=$KUBE_VERSION --pod-network-cidr=10.244.0.0/16 >> /tmp/kubeadminit.txt
else
    kubeadm init --kubernetes-version=$KUBE_VERSION --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$KUBE_ADVERTISE_IP >> /tmp/kubeadminit.txt
fi

mkdir -p ~/.kube/
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

kubectl create -f preps/kube-flannel.yml
sleep 2
kubectl create -f preps/kube-flannel-rbac.yml
sleep 2
kubectl create -f preps/kubernetes-dashboard.yaml
sleep 2

cp "/etc/kubernetes/admin.conf" /tmp/
chmod 666 "/tmp/admin.conf"

watch kubectl get po --all-namespaces
