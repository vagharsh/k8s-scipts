#!/bin/bash

## Script for Bootstraping Consul Cluster

scriptVersion=1.0
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

export default_iface=$(route | grep default | awk '{print $(NF)}')
export defailt_ip=$(ip addr show dev "${default_iface}" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')
export docker_ip=$(ip addr show dev "docker0" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }')


docker run -d -h master --restart=always -v /opt/consul/data:/data:Z \
    -p ${defailt_ip}:8300:8300 \
    -p ${defailt_ip}:8301:8301 \
    -p ${defailt_ip}:8301:8301/udp \
    -p ${defailt_ip}:8302:8302 \
    -p ${defailt_ip}:8302:8302/udp \
    -p ${defailt_ip}:8400:8400 \
    -p ${defailt_ip}:8500:8500 \
    -p ${docker_ip}:53:53/udp \
    progrium/consul -server -advertise ${defailt_ip} -bootstrap-expect ${count}

echo "Master IP is : ${defailt_ip}"
echo "Cluster Size is ${count}"
echo "Use this ip for Nodes"