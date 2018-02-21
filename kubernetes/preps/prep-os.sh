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

yum update -y
yum install -y -q wget net-tools vim ntpdate device-mapper-persistent-data lvm2 yum-utils git

# Set timezone
timedatectl set-timezone ${TIMEZONE}

cp -f confs/k8s.conf /etc/sysctl.d/k8s.conf
sysctl --system

# disable SeLinux
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab