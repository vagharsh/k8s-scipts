#!/bin/bash

scriptVersion=1.2
scriptName="OS Preparation script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

key="^exclude.*"
listOfExcludes=`cat /etc/yum.conf | grep "exclude="`
lengthOfExclude=`echo ${#listOfExcludes}`
if [ "$lengthOfExclude" -gt 0 ]; then
	tobeExcluded=$listOfExcludes" kernel*"
	sed -i -e "s~$key~$tobeExcluded~" "/etc/yum.conf"
else
	echo "exclude=kernel*" >> "/etc/yum.conf"
fi

source ./envvars.sh

yum update -y
yum install -y -q wget net-tools vim ntpdate device-mapper-persistent-data lvm2 yum-utils git

# Set timezone
timedatectl set-timezone ${TIMEZONE}

# Setup ntp
ntpdate -q  0.ro.pool.ntp.org  1.ro.pool.ntp.org
systemctl enable ntpdate && systemctl start ntpdate

# Disable firewall
systemctl disable firewalld && systemctl stop firewalld

# iptables bypassing
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# disable SeLinux
#sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
setenforce 0

# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab