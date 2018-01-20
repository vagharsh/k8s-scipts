#!/bin/bash

source ./envvars.sh

usage() { echo "Please fill the NAMESPACE parameter in envvars.sh file" 1>&2; exit 1; }

if [ -z "$NAMESPACE" ]; then
  usage
fi

for i in ${NAMESPACE[@]}; do
    namespace=${i}
    kubectl create -f ns "$namespace"
    echo "A ClusterRoleBinding rule is being created with VIEW clusterrole for $namespace"
    kubectl create clusterrolebinding "$namespace-cluster-view-binding" --clusterrole view --serviceaccount="$namespace":default
done