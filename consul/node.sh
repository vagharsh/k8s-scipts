#!/bin/bash

## Script for  setup Consul Nodes

# Input Consul Cluster Size

scriptVersion=1.1
scriptName="Consul Node Bootstrap script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

echo "Enter Consul Master IP and press [ENTER]: "
read master_ip

echo "Enter Node Hostname (like node1, node2, node3 ....) and press [ENTER]: "
read node_name

# Remove Consul Data Directory and create with Selinux flag.

rm -rf /opt/consul/data
mkdir -p /opt/consul/data
chcon -Rt svirt_sandbox_file_t /opt/consul/data

export default_iface=$(route | grep default | awk '{print $(NF)}')
export default_ip=$(ip addr show dev "${default_iface}" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')
export docker_ip=$(ip addr show dev "docker0" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')

docker run -d -h ${node_name} --restart=always -v /opt/consul/data:/data:Z \
    -p ${default_ip}:8300:8300 \
    -p ${default_ip}:8301:8301 \
    -p ${default_ip}:8301:8301/udp \
    -p ${default_ip}:8302:8302 \
    -p ${default_ip}:8302:8302/udp \
    -p ${default_ip}:8400:8400 \
    -p ${default_ip}:8500:8500 \
    -p ${docker_ip}:53:53/udp \
    progrium/consul -server -advertise ${default_ip} -join ${master_ip}

echo "Master IP is : ${master_ip}"