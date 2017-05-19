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

systemctl enable docker