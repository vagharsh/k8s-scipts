#!/bin/bash

yum update -y
yum -y -q install yum-utils wget net-tools

cp -f confs/k8s.conf /etc/sysctl.d/k8s.conf