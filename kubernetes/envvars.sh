#!/bin/bash -x

export DOCKER_BIP="10.250.250.1/24"
export BLOCK_DEVICE="/dev/sdb"
export KUBE_VERSION=""
export KUBE_ADVERTISE_IP=""
export NAMESPACE=("demo" "prod")
export TIMEZONE="Asia/Yerevan"
export DEFAULT_NIC="eth0"