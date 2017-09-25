#!/bin/bash

DOCKER_BIP=${1:-10.250.250.1/24}    

mkdir /etc/docker
chmod 700 /etc/docker

envsubst < "confs/daemon.json" > "/etc/docker/daemon.json"