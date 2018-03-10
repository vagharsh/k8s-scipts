#!/bin/bash

scriptVersion=1.3
scriptName="Post initialization script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

usage() { echo "Please fill the NAMESPACE parameter in envvars.sh file" 1>&2; exit 1; }

watch kubectl get po --all-namespaces

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sleep 1
kubectl apply -f confs/dashboard_rbac.yaml
sleep 1
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
sleep 1

if [ -z "$NAMESPACE" ]; then
  usage
fi

for i in ${NAMESPACE[@]}; do
    namespace=${i}
    kubectl create ns "$namespace"
    echo "A ClusterRoleBinding rule is being created with VIEW clusterrole for $namespace"
    kubectl create clusterrolebinding "$namespace-cluster-view-binding" --clusterrole view --serviceaccount="$namespace":default
done

watch kubectl get po --all-namespaces