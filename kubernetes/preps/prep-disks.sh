#!/bin/bash

scriptVersion=1.3
scriptName="Docker Disks Preparation script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

# Remove OLD LVM, VG, PV if exists
STATUS=`pvs | grep ${BLOCK_DEVICE} | wc -l`
if [ $STATUS -eq 1 ]; then
    lvremove -f docker thinpool
    vgremove -f docker
    pvremove -f ${BLOCK_DEVICE}
fi

# Create PV
pvcreate -ff ${BLOCK_DEVICE}

# Create VG
vgcreate -ff docker ${BLOCK_DEVICE}

# Create LVs
lvcreate --wipesignatures y -n thinpool docker -l 95%VG
lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG

# Convert LVs
lvconvert -y \
--zero n \
-c 512K \
--thinpool docker/thinpool \
--poolmetadata docker/thinpoolmeta

# Apply profile
mkdir -p /etc/lvm/profile/
cp -f confs/docker-thinpool.profile /etc/lvm/profile/docker-thinpool.profile
lvchange --metadataprofile docker-thinpool docker/thinpool