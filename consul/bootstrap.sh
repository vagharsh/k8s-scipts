#!/bin/bash

## Script for Bootstraping Consul Cluster

scriptVersion=1.1
scriptName="Consul Master Bootstrap script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

# Input Consul Cluster Size

echo "Enter Consul Cluster Size (Servers Count) and press [ENTER]: "
read count

# Remove Consul Data Directory and create with Selinux flag.

rm -rf /opt/consul/data
mkdir -p /opt/consul/data
chcon -Rt svirt_sandbox_file_t /opt/consul/data

## Find Default private ip address of server

ip a

#export default_iface=$(route | grep default | awk '{print $(NF)}')
read -e -p "Enter the interface name which you want consul to setup on " default_iface
export default_iface
export default_ip=$(ip addr show dev "${default_iface}" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')
export docker_ip=$(ip addr show dev "docker0" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')


docker run -d -h master --restart=always -v /opt/consul/data:/data:Z \
    -p ${default_ip}:8300:8300 \
    -p ${default_ip}:8301:8301 \
    -p ${default_ip}:8301:8301/udp \
    -p ${default_ip}:8302:8302 \
    -p ${default_ip}:8302:8302/udp \
    -p ${default_ip}:8400:8400 \
    -p ${default_ip}:8500:8500 \
    -p ${docker_ip}:53:53/udp \
    progrium/consul -server -advertise ${default_ip} -bootstrap-expect ${count}

echo "Master IP is : ${default_ip}"
echo "Cluster Size is ${count}"
echo "Use this ip for Nodes"