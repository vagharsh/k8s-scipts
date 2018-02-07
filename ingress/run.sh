#!/bin/bash

scriptVersion=1.1
scriptName="Ingress Deployment script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"\

source envvars.sh

usage() { echo "Please fill the NAMESPACE parameter in envvars.sh file" 1>&2; exit 1; }

if [ -z "$NAMESPACE" ]; then
  usage
fi

echo "[INFO] Creating nginx Ingress controller rbac rule"
kubectl create -f nginx-ingress-controller-rbac.yml

echo "[INFO] Creating nginx Ingress default backend rule"
kubectl create -f default-backend.yaml 

echo "[INFO] Creating nginx config map rule"
kubectl create -f nginx-config.yaml

echo "[INFO] Creating nginx Ingress service rule"
kubectl create -f nginx-ingress-svc.yaml

echo "[INFO] Creating nginx Ingress replication controller rule"
envsubst < nginx-ingress-rc.yaml | kubectl create -f -

for i in ${NAMESPACE[@]}; do
	export namespace=${i}
	kubectl create clusterrolebinding all-view --clusterrole view --serviceaccount=$namespace:default
	read -e -p "Enter ingress host-name for << $namespace >> e.g. kube-demo.test.com : " ingressHost
	
	cp ingress.yaml newIngress.yaml
	newIngress='"'$ingressHost'"'
	sed -i -e "s/{{INGRESS}}/$newIngress/g" newIngress.yaml

	echo "[INFO] Creating Ingress for $namespace"
	envsubst < newIngress.yaml | kubectl create -f -
	rm -f newIngress.yaml
done
