#!/bin/bash -x

export DOCKER_BIP="10.250.250.1/24"
export BLOCK_DEVICE="/dev/sdb"
export KUBE_VERSION="" # e.g. ( v1.6.7 )
export KUBE_ADVERTISE_IP="" # The IP address the API Server will advertise it's listening on.
export NAMESPACE=("demo" "prod")
export TIMEZONE="Asia/Yerevan"