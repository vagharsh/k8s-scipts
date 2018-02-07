#!/bin/bash

echo "You are running Latest Kubernetes version Deployment Script as WORKER"
echo ""

if [ "$EUID" -ne 0 ]; then 
	echo "Please run as root"
	read -rsp $'Press any key to Exit...\n' -n1 key
	exit
else 
	echo "Running as root" 
fi
echo ""

./preps/prep-os.sh

sleep 1

./preps/prep-disks.sh

sleep 1

./preps/prep-daemon.sh

sleep 1

./preps/docker-setup.sh

sleep 1

./preps/k8s-setup.sh