#!/bin/bash

scriptVersion=1.1
scriptName="Kubernetes (Master / Worker) Node Setup script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
yum install -y kubelet kubeadm kubectl

key="^exclude.*"
listOfExcludes=`cat /etc/yum.conf | grep "exclude="`
lengthOfExclude=`echo ${#listOfExcludes}`
if [ "$lengthOfExclude" -gt 0 ]; then
	tobeExcluded=$listOfExcludes" kube*"
	sed -i -e "s~$key~$tobeExcluded~" "/etc/yum.conf"
else
	echo "exclude=kube*" >> "/etc/yum.conf"
fi

regKey="^Environment=\"KUBELET_CGROUP_ARGS.*"
regValue="Environment=\"KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs\"" 

sed -i -e "s~$regKey~$regValue~" "/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"

systemctl stop firewalld && systemctl disable firewalld
systemctl daemon-reload && systemctl enable kubelet && systemctl start kubelet