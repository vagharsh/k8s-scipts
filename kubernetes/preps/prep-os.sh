#!/bin/bash

scriptVersion=1.1
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
yum -y -q install yum-utils wget net-tools

cp -f confs/k8s.conf /etc/sysctl.d/k8s.conf
sysctl --system

swapoff -a