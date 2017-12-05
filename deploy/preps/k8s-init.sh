#!/bin/bash

source ./envvars.sh

cat <<EOF
**********************************************************
Initializing Kubeadm, it might take a minute or so ......
**********************************************************
EOF

kubeadm init --kubernetes-version=$KUBE_VERSION --pod-network-cidr=10.244.0.0/16 >> /tmp/kubeadminit.txt

mkdir -p ~/.kube/
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

<<<<<<< HEAD
kubectl create -f preps/kube-flannel-rbac.yml
sleep 2
kubectl create -f preps/kube-flannel.yml
=======

#kubectl create -f preps/kube-flannel-legacy.yml
#sleep 2
#kubectl create -f preps/kube-flannel-rbac.yml
kubectl create -f https://raw.githubusercontent.com/coreos/flannel/cff39eeb3d0dd3710f83b5eba7bde1afa8fa2d46/Documentation/kube-flannel.yml
>>>>>>> 7894614bec42fea52083ddbe398436ebdd27be16
sleep 2
kubectl create -f preps/kubernetes-dashboard.yaml
sleep 2

IFS=' ' read -r -a ipAddrs <<< `hostname --all-ip-addresses`

kubekey=`cat /tmp/kubeadminit.txt`
tokenkey=`echo "${kubekey##*$'\n'}"`
tokenkey=`echo ${tokenkey:22:24}`

echo $tokenkey > /tmp/tokenkey.txt
cp "/etc/kubernetes/admin.conf" /tmp/
chmod 666 "/tmp/admin.conf"

cat <<EOF
***********************************************
Dashboard URL is: https://${ipAddrs[0]}:6443/ui
Dashboard Token is: $tokenkey
***********************************************
EOF

watch kubectl get po --all-namespaces
