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

sudo yum install -y kubelet kubeadm kubectl kubernetes-cni 
echo "exclude=kube*">> "/etc/yum.conf"

sudo setenforce 0

systemctl disable firewalld && systemctl disable iptables-services
systemctl stop firewalld && systemctl stop iptables-services

systemctl start docker
systemctl enable kubelet && systemctl daemon-reload && systemctl start kubelet

echo "**********************************************************"
echo "Initializing Kubeadm, it might take a minute or so ......"
echo "**********************************************************"

echo "net.bridge.bridge-nf-call-ip6tables = 1" > /etc/sysctl.d/k8s.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/k8s.conf

sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.bridge.bridge-nf-call-ip6tables=1

kubeadm init --pod-network-cidr=10.244.0.0/16 >> /tmp/kubeadminit.txt

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
#rm -f /tmp/kubeadminit.txt

echo $tokenkey > /tmp/tokenkey.txt
cp "/etc/kubernetes/admin.conf" /tmp/
chmod 666 "/tmp/admin.conf"

echo $'\n ********************************************** '
echo "Dashboard URL is: https://${ipAddrs[0]}:6443/ui"
echo "Dashboard Token is: $tokenkey"
echo $' ********************************************** \n'

watch kubectl get po --all-namespaces