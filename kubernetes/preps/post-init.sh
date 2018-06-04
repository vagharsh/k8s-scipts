#!/bin/bash

scriptVersion=1.5
scriptName="Post initialization script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

if [ -z "$NAMESPACE" ]; then
  usage
fi

usage() { echo "Please fill the NAMESPACE parameter in envvars.sh file" 1>&2; exit 1; }

watch kubectl get po --all-namespaces

if [ ${#POD_CIDR} -le 0 ]; then
  export kubever=$(kubectl version | base64 | tr -d '\n')
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
else 
  flannelYAML="confs/kube-flannel.yml"
  wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml --output-document="$flannelYAML"
  sed -i -e "s~10.244.0.0/16~$POD_CIDR~" "$flannelYAML"
  kubectl apply -f "$flannelYAML"
  sleep 1
  rm -rf  "$flannelYAML"
fi

sleep 1
kubectl apply -f confs/dashboard_rbac.yaml
sleep 1
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
sleep 1

for i in ${NAMESPACE[@]}; do
    namespace=${i}
    kubectl create ns "$namespace"
    echo "A ClusterRoleBinding rule is being created with VIEW clusterrole for $namespace"
    kubectl create clusterrolebinding "$namespace-cluster-view-binding" --clusterrole view --serviceaccount="$namespace":default
done

watch kubectl get po --all-namespaces