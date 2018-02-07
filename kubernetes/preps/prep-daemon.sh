#!/bin/bash

scriptVersion=1.0
scriptName="Docker Daemon Preparation script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

mkdir /etc/docker
chmod 700 /etc/docker

envsubst < "confs/daemon.json" > "/etc/docker/daemon.json"