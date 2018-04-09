#!/bin/bash

<<<<<<< HEAD
scriptVersion=1.6
=======
scriptVersion=1.4
>>>>>>> d07f7a0e7b2395b7d67349a164625954ed394054
scriptName="Kubernetes Single Master node Initialization script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

cat <<EOF
**********************************************************
Initializing Kubeadm, it might take a minute or so ......
**********************************************************
EOF

mkdir -p /etc/kubernetes/pki/
cp -rf certificates/* /etc/kubernetes/pki/
chmod 600 /etc/kubernetes/pki/*.key /etc/kubernetes/pki/*.pub
chmod 644 /etc/kubernetes/pki/*.crt

cp -f certificates/ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

if [ ${#KUBE_VERSION} -le 0 ]; then
    if [ ${#KUBE_ADVERTISE_IP} -le 0 ]; then
<<<<<<< HEAD
        if [ ${#POD_CIDR} -le 0 ]; then
            kubeadm init >> /tmp/kubeadminit.txt
        else
            kubeadm init --pod-network-cidr=$POD_CIDR >> /tmp/kubeadminit.txt
        fi 
    else
        if [ ${#POD_CIDR} -le 0 ]; then
            kubeadm init \
            --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
            >> /tmp/kubeadminit.txt
        else
            kubeadm init --pod-network-cidr=$POD_CIDR \
            --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
            >> /tmp/kubeadminit.txt
        fi        
    fi
else
    if [ ${#KUBE_ADVERTISE_IP} -le 0 ]; then
        if [ ${#POD_CIDR} -le 0 ]; then
            kubeadm init --kubernetes-version=$KUBE_VERSION >> /tmp/kubeadminit.txt
        else
            kubeadm init --kubernetes-version=$KUBE_VERSION \
                --pod-network-cidr=$POD_CIDR \
                >> /tmp/kubeadminit.txt
        fi
    else
        if [ ${#POD_CIDR} -le 0 ]; then
            kubeadm init --kubernetes-version=$KUBE_VERSION \
                --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
                >> /tmp/kubeadminit.txt
        else
            kubeadm init --kubernetes-version=$KUBE_VERSION \
                --pod-network-cidr=$POD_CIDR \
                --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
                >> /tmp/kubeadminit.txt
        fi
=======
        kubeadm init \
            --pod-network-cidr=10.244.0.0/16 \
            >> /tmp/kubeadminit.txt
    else
        kubeadm init \
            --pod-network-cidr=10.244.0.0/16 \
            --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
            >> /tmp/kubeadminit.txt
    fi
else
    if [ ${#KUBE_ADVERTISE_IP} -le 0 ]; then
        kubeadm init \
            --kubernetes-version=$KUBE_VERSION \
            --pod-network-cidr=10.244.0.0/16 \
            >> /tmp/kubeadminit.txt
    else 
        kubeadm init \
            --kubernetes-version=$KUBE_VERSION \
            --pod-network-cidr=10.244.0.0/16 \
            --apiserver-advertise-address=$KUBE_ADVERTISE_IP \
            >> /tmp/kubeadminit.txt
>>>>>>> d07f7a0e7b2395b7d67349a164625954ed394054
    fi
fi

mkdir -p ~/.kube/
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

cp "/etc/kubernetes/admin.conf" /tmp/
chmod 666 "/tmp/admin.conf"