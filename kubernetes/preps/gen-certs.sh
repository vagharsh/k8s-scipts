#!/bin/bash
set -e

scriptVersion=1.1
scriptName="Kubernetes Certificates generator script"
echo "*** You are Running $scriptName, Version : $scriptVersion ***"

source ./envvars.sh

# Environment Variables
export PRIVATE_IP=$(ip addr show ${DEFAULT_NIC} | grep -Po 'inet \K[\d.]+')

if [ ${#KUBE_ADVERTISE_IP} -le 0 ]; then
    KUBE_ADVERTISE_IP=$PRIVATE_IP
fi

# generate Kubernetes CA certs
mkdir -p certificates
cd certificates

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj "/CN=${KUBE_ADVERTISE_IP}" -days 3650 -out ca.crt

openssl genrsa -out sa.key 2048
openssl rsa -in sa.key -pubout > sa.pub

cat <<-EOF_api-ext > api-ext.cnf
 [ v3_ca ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName          = @alternate_names
[ alternate_names ]
DNS.1           = $KUBE_ADVERTISE_NAME
DNS.2           = kubernetes
DNS.3           = kubernetes.default
DNS.4           = kubernetes.default.svc
DNS.5           = kubernetes.default.svc.cluster.local
IP.1            = $KUBE_ADVERTISE_IP
IP.2            = 10.96.0.1
EOF_api-ext

cat <<-'EOF_default-ext' > default-ext.cnf
 [ v3_ca ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF_default-ext

openssl genrsa -out apiserver.key 2048
openssl req -new -key apiserver.key -out apiserver.csr -subj "/CN=kube-apiserver"
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -sha256 -out apiserver.crt -extensions v3_ca -extfile api-ext.cnf -days 3650

openssl genrsa -out apiserver-kubelet-client.key 2048
openssl req -new -key apiserver-kubelet-client.key -out apiserver-kubelet-client.csr -subj "/O=system:masters/CN=kube-apiserver-kubelet-client"
openssl x509 -req -in apiserver-kubelet-client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -sha256 -out apiserver-kubelet-client.crt -extensions v3_ca -extfile default-ext.cnf -days 3650

openssl genrsa -out front-proxy-ca.key 2048
openssl req -x509 -new -nodes -key front-proxy-ca.key -subj "/CN=kubernetes" -days 3650 -out front-proxy-ca.crt

openssl genrsa -out front-proxy-client.key 2048
openssl req -new -key front-proxy-client.key -out front-proxy-client.csr -subj "/CN=front-proxy-client"
openssl x509 -req -in front-proxy-client.csr -CA front-proxy-ca.crt -CAkey front-proxy-ca.key -CAcreateserial -sha256 -out front-proxy-client.crt -extensions v3_ca -extfile default-ext.cnf -days 3650

rm -rf *.csr *.cnf *.srl

cd ..