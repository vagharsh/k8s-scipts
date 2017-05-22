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

./docker-setup.sh

mkdir /etc/docker
chmod 700 /etc/docker
cp -rf daemon.json /etc/docker/daemon.json

sleep 1

./k8s-worker-setup.sh

sleep 1

#echo "Server will be reboot after 10 seconds for complete setup."
#secs=$((10))
#while [ $secs -gt 0 ]; do
#   echo -ne "$secs\033[0K\r"
#   sleep 1
#   : $((secs--))
#done

#reboot