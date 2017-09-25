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

key="^exclude.*"
listOfExcludes=`cat /etc/yum.conf | grep "exclude="`
lengthOfExclude=`echo ${#listOfExcludes}`
if [ "$lengthOfExclude" -gt 0 ]; then
	tobeExcluded=$listOfExcludes" docker*"
	sed -i -e "s~$key~$tobeExcluded~" "/etc/yum.conf"
else
	echo "exclude=docker*" >> "/etc/yum.conf"
fi

#regKey="^ExecStart=/usr.*"
#regValue="ExecStart=/usr/bin/dockerd --exec-opt native.cgroupdriver=systemd" 

#sed -i -e "s~$regKey~$regValue~" "/usr/lib/systemd/system/docker.service"

systemctl enable docker