#!/bin/bash

scriptVersion=1.0
scriptName="Docker Setup script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

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

systemctl enable docker
