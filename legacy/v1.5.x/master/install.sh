#!/bin/bash

echo "You are running Kubernetes version 1.5.x Deployment Script as MASTER"
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

./docker-setup.sh

sleep 1

./k8s-master-setup.sh

sleep 1

#echo "Server will be reboot after 10 seconds for complete setup."
#secs=$((10))
#while [ $secs -gt 0 ]; do
#   echo -ne "$secs\033[0K\r"
#   sleep 1
#   : $((secs--))
#done

#reboot