#!/bin/bash

## Script for  setup Consul Nodes

# Input Consul Cluster Size

echo "Enter Consul Master IP and press [ENTER]: "
read master_ip

echo "Enter Node hostname (like node1, node2, node3 ....) and press [ENTER]: "
read node_name


# Remove Consul Data Directory and create with Selinux flag.

rm -rf /opt/consul/data
mkdir -p /opt/consul/data
chcon -Rt svirt_sandbox_file_t /opt/consul/data

## Find Default private ip address of server

export default_iface=$(route | grep default | awk '{print $(NF)}')
export defailt_ip=$(ip addr show dev "${default_iface}" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')
export docker_ip=$(ip addr show dev "docker0" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')


docker run -d -h ${node_name} --restart=always -v /opt/consul/data:/data:Z \
    -p ${defailt_ip}:8300:8300 \
    -p ${defailt_ip}:8301:8301 \
    -p ${defailt_ip}:8301:8301/udp \
    -p ${defailt_ip}:8302:8302 \
    -p ${defailt_ip}:8302:8302/udp \
    -p ${defailt_ip}:8400:8400 \
    -p ${defailt_ip}:8500:8500 \
    -p ${docker_ip}:53:53/udp \
    progrium/consul -server -advertise ${defailt_ip} -join ${master_ip}



echo "Master IP is : ${master_ip}"
