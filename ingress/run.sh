#!/bin/bash

scriptVersion=1.2
scriptName="Kubernetes Ingress Deployment script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source envvars.sh

usage() { echo "Please fill the NAMESPACE parameter in envvars.sh file" 1>&2; exit 1; }

if [ -z "$NAMESPACE" ]; then
  usage
fi

# Mandatory commands
echo "[INFO] Creating Kubernetes Ingress Namespace"
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml \
    | kubectl apply -f -

echo "[INFO] Creating Kubernetes Ingress Default-Backend"
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/default-backend.yaml \
    | kubectl apply -f -

echo "[INFO] Creating Kubernetes Ingress Config Map"
kubectl apply -f config-map.yaml

echo "[INFO] Creating Kubernetes Ingress TCP Service Config Map"
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/tcp-services-configmap.yaml \
    | kubectl apply -f -

echo "[INFO] Creating Kubernetes Ingress UDP Service Config Map"
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/udp-services-configmap.yaml \
    | kubectl apply -f -


# Deployment with RBAC roles
echo "[INFO] Creating Kubernetes Ingress RBAC roles"
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/rbac.yaml \
    | kubectl apply -f -

echo "[INFO] Creating Kubernetes Ingress Deployment"
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/with-rbac.yaml \
    | kubectl apply -f -

echo "[INFO] Creating nginx Ingress service rule"
kubectl create -f ingress-svc.yaml

for i in ${NAMESPACE[@]}; do
	export namespace=${i}
	read -e -p "Enter ingress host-name for << $namespace >> e.g. kube-demo.test.com : " ingressHost

	cp ingress.yaml newIngress.yaml
	newIngress='"'$ingressHost'"'
	sed -i -e "s/{{INGRESS}}/$newIngress/g" newIngress.yaml

	echo "[INFO] Creating Ingress for $namespace"
	envsubst < newIngress.yaml | kubectl create -f -
	rm -f newIngress.yaml
done