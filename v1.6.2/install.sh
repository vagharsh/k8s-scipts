#!/bin/bash

yum update -y

yum install -y yum-utils wget net-tools

cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum install -y docker-engine-1.12.6

echo "exclude=docker*">> "/etc/yum.conf"

IFS=' ' read -r -a ipAddrs <<< `hostname --all-ip-addresses`
IFS='.' read -ra ADDR <<< "${ipAddrs[0]}"

regKey="^ExecStart=/usr.*"
regValue="ExecStart=/usr/bin/dockerd --bip=192.168.${ADDR[3]}.1/24 --exec-opt native.cgroupdriver=systemd" 

sed -i -e "s~$regKey~$regValue~" "/usr/lib/systemd/system/docker.service"

systemctl enable docker && systemctl disable firewalld && systemctl stop firewalld && systemctl start docker

setenforce 0

rpm -ivh kubelet*.rpm kubernetes-cni*.rpm kubectl*.rpm kubeadm*.rpm

systemctl enable kubelet && systemctl start kubelet

echo "**********************************************************"
echo "Initializing Kubeadm, it might take a minute or so ......"
echo "**********************************************************"

kubeadm init --pod-network-cidr=10.244.0.0/16 >> /tmp/kubeadminit.txt

mkdir -p ~/.kube/
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
export KUBECONFIG=~/.kube/config

echo "net.bridge.bridge-nf-call-ip6tables = 1" > /etc/sysctl.d/k8s.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/k8s.conf

kubectl create -f kube-flannel-rbac.yml
sleep 2
kubectl create -f kube-flannel.yml
sleep 2
kubectl create -f kubernetes-dashboard.yaml
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