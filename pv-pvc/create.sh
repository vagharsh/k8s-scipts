#!/bin/bash

scriptVersion=1.0
scriptName="PV-PVC Creation script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source envvars.sh

usage() { echo "Please fill the NAMESPACE parameter in envvars.sh file" 1>&2; exit 1; }

if [ -z "$NAMESPACE" ]; then
  usage
fi

echo "[INFO] Creating Persistant Volume as $FOR_SVC_NAME-pv-$NAMESPACE"
envsubst < pv.json | kubectl create -f -

echo "[INFO] Creating Persistant Volume Claim as $FOR_SVC_NAME-pvc"
envsubst < pvc.json | kubectl create -f -