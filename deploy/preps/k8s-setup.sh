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

key="^exclude.*"
listOfExcludes=`cat /etc/yum.conf | grep "exclude="`
lengthOfExclude=`echo ${#listOfExcludes}`
if [ "$lengthOfExclude" -gt 0 ]; then
	tobeExcluded=$listOfExcludes" kube*"
	sed -i -e "s~$key~$tobeExcluded~" "/etc/yum.conf"
else
	echo "exclude=kube*" >> "/etc/yum.conf"
fi

sudo setenforce 0

regKey="^Environment=\"KUBELET_CGROUP_ARGS.*"
regValue="Environment=\"KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs\"" 

sed -i -e "s~$regKey~$regValue~" "/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"

systemctl disable firewalld && systemctl disable iptables-services
systemctl stop firewalld && systemctl stop iptables-services

systemctl start docker
systemctl daemon-reload && systemctl enable kubelet && systemctl start kubelet