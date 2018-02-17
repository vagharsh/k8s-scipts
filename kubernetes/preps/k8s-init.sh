#!/bin/bash

scriptVersion=1.1
scriptName="Kubernetes Master node Initialization script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

cat <<EOF
**********************************************************
Initializing Kubeadm, it might take a minute or so ......
**********************************************************
EOF

insertKubeVersion = "--kubernetes-version=$KUBE_VERSION"
kubeAdvertiseIP = "--apiserver-advertise-address=$KUBE_ADVERTISE_IP"

kubeadm init $insertKubeVersion --pod-network-cidr=10.244.0.0/16 $kubeAdvertiseIP >> /tmp/kubeadminit.txt

mkdir -p ~/.kube/
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
sleep 1
kubectl apply -f preps/dashboard_rbac.yaml
sleep 1
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
sleep 1

cp "/etc/kubernetes/admin.conf" /tmp/
chmod 666 "/tmp/admin.conf"

watch kubectl get po --all-namespaces
