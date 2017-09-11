#!/bin/bash

echo "You are running Latest Kubernetes version Deployment Script as WORKER"
echo ""

if [ "$EUID" -ne 0 ]; then 
	echo "Please run as root"
	read -rsp $'Press any key to Exit...\n' -n1 key
	exit
else 
	echo "Running as root" 
	#read -rsp $'Press any key to continue...\n' -n1 key
fi
echo ""

./prep-disks.sh

sleep 1

IFS=' ' read -r -a ipAddrs <<< `hostname --all-ip-addresses`
IFS='.' read -ra ADDR <<< "${ipAddrs[0]}"

printf '{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "50m",
        "max-file": "5"
    },
    "bip":"'192.168.${ADDR[3]}.1/24'",
    "live-restore": true,
    "storage-driver": "devicemapper",
    "storage-opts": [
        "dm.thinpooldev=/dev/mapper/docker-thinpool",
        "dm.use_deferred_removal=true",
        "dm.use_deferred_deletion=true"
    ]
}' > daemon.json

mkdir /etc/docker
chmod 700 /etc/docker
cp -rf daemon.json /etc/docker/daemon.json

sleep 1

./docker-setup.sh

sleep 1

./k8s-setup.sh

sleep 1