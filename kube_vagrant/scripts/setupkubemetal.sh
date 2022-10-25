#!/usr/bin/env bash

sudo apt-get update && sudo apt-get -y upgrade

echo "Install Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "Create SSL on LB IP"
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -addext "subjectAltName = DNS:192.168.2.50.nip.io" -keyout privateKey.key -out certificate.crt -subj "/C=US/ST=CA/L=LA/O=Dis/CN=192.168.2.50.nip.io"

echo "Create Address Pool"
cat <<EOF >> pool1.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: default
spec:
  addresses:
  - 192.168.2.50-192.168.2.55
EOF

#echo "Installing K8s"
#curl https://kurl.sh/latest | sudo bash -s private-address="192.168.6.10"

#echo "Install Metal Load Balancer"
#helm repo add metallb https://metallb.github.io/metallb
#helm repo update
#helm install metallb metallb/metallb

#echo "Apply Address Pool"
#sudo kubectl apply -f pool1.yaml

