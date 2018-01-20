#!/bin/bash -x

export DOCKER_BIP="10.250.250.1/24"
export BLOCK_DEVICE="/dev/sdb"
export KUBE_VERSION="v1.6.7"
export NAMESPACE=("demo" "prod")
