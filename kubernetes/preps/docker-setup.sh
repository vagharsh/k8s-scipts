#!/bin/bash

scriptVersion=1.1
scriptName="Docker Setup script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce -y

sudo yum-config-manager --disable docker-ce

systemctl enable docker && systemctl start docker