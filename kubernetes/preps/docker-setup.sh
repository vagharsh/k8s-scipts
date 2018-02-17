#!/bin/bash

scriptVersion=1.1
scriptName="Docker Setup script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

yum install -y docker

key="^exclude.*"
listOfExcludes=`cat /etc/yum.conf | grep "exclude="`
lengthOfExclude=`echo ${#listOfExcludes}`
if [ "$lengthOfExclude" -gt 0 ]; then
	tobeExcluded=$listOfExcludes" docker*"
	sed -i -e "s~$key~$tobeExcluded~" "/etc/yum.conf"
else
	echo "exclude=docker*" >> "/etc/yum.conf"
fi

systemctl enable docker && systemctl start docker