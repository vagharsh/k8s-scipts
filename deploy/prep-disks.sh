#!/bin/bash

yum update -y

yum -y -q install lvm2

#Create a physical volume replacing /dev/xvdf with your block device.
pvcreate -ff /dev/sdb

sleep 5

#Create a ‘docker’ volume group.
vgcreate docker /dev/sdb

sleep 5

#Create a thin pool named thinpool.
#In this example, the data logical is 95% of the ‘docker’ volume group size.
#Leaving this free space allows for auto expanding of either the data or metadata if space runs low as a temporary stopgap.
lvcreate --wipesignatures y -n thinpool docker -l 95%VG
sleep 5
lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG

sleep 5
#Convert the pool to a thin pool.
lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta

#Clearing your graph driver removes any images, containers, and volumes in your Docker installation.
rm -rf /var/lib/docker/*

# Copy thinpool profile file
cp -rf docker-thinpool.profile /etc/lvm/profile/docker-thinpool.profile
chmod 444 /etc/lvm/profile/docker-thinpool.profile
sleep 1
#Apply your new lvm profile
lvchange --metadataprofile docker-thinpool docker/thinpool
sleep 5
