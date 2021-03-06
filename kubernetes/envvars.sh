#!/bin/bash -x

export DOCKER_BIP="10.250.250.1/24"
export POD_CIDR="10.250.0.0/16"
export BLOCK_DEVICE="/dev/sdb"
export KUBE_VERSION=""
export KUBE_ADVERTISE_IP=""
export KUBE_ADVERTISE_NAME="foo.bar.com"
export NAMESPACE=("demo")
export TIMEZONE="Asia/Yerevan"
export DEFAULT_NIC="eth0"