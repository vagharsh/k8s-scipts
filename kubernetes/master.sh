#!/bin/bash

echo "You are running Latest Kubernetes version Deployment Script as MASTER"
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

./preps/prep-disks.sh $BLOCK_DEVICE

sleep 1

./preps/prep-daemon.sh $DOCKER_BIP

sleep 1

./preps/docker-setup.sh

sleep 1

./preps/k8s-setup.sh $KUBE_VERSION

sleep 1

./preps/k8s-init.sh

sleep 1

./preps/post-init.sh

sleep 1