#!/bin/bash

scriptVersion=1.2
scriptName="Docker Disks Preparation script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

# Create PV
pvcreate ${BLOCK_DEVICE}

# Create VG
vgcreate docker ${BLOCK_DEVICE}

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
cp -rf confs/docker-thinpool.profile /etc/lvm/profile/docker-thinpool.profile
lvchange --metadataprofile docker-thinpool docker/thinpool