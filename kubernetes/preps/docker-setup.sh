#!/bin/bash
set -e

scriptVersion=1.2
scriptName="Docker Setup script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

# Environment Variables
export FULLY_QUALIFIED_PACKAGE_NAME='docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm'
export SELINUX_PACKAGE_NAME="docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm"
export DOCKER_RPM_URL="https://download.docker.com/linux/centos/7/x86_64/stable/Packages/${FULLY_QUALIFIED_PACKAGE_NAME}"
export DOCKER_SELINUX_RPM_URL="https://download.docker.com/linux/centos/7/x86_64/stable/Packages/${SELINUX_PACKAGE_NAME}"

# Dowload Docker rpm
wget ${DOCKER_RPM_URL}
wget ${DOCKER_SELINUX_RPM_URL}

# Install Docker and SeLinux
yum install -y docker-ce-selinux-17.03.2.ce
yum install -y docker-ce-17.03.2.ce

# Configure Docker
mkdir -p /etc/docker && chmod 700 /etc/docker
envsubst < confs/daemon.json > /etc/docker/daemon.json

# Enable at boot and start Docker
systemctl enable docker && systemctl start docker

# Remove docker installer
rm -rf ${FULLY_QUALIFIED_PACKAGE_NAME}
rm -rf ${SELINUX_PACKAGE_NAME}