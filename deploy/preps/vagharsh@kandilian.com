#!/bin/bash

KUBE_VERSION=${1:-v1.6.7}    

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

kubectl create -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
sleep 2
kubectl create -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sleep 2
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
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
