#!/bin/bash

source ./envvars.sh

mkdir /etc/docker
chmod 700 /etc/docker

envsubst < "confs/daemon.json" > "/etc/docker/daemon.json"