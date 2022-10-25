#!/usr/bin/env bash

echo "Installing Docker"

 curl -fsSL get.docker.com | CHANNEL=stable sh
 sleep 15
 sudo apt install docker-ce
 sleep 15
 sudo apt-get install docker-ce docker-ce-cli containerd.io
 sleep 15

echo "Enable Docker Service"

 systemctl status docker
 sleep 5
 sudo systemctl enable docker.service
 sleep 5
 sudo systemctl enable containerd.service 
 sleep 5

echo "Setup Registry Auth"

mkdir "$(pwd)"/auth

sudo docker run \
  --entrypoint htpasswd \
  httpd:2 -Bbn admin admin > "$(pwd)"/auth/htpasswd

echo "Update docker daemon.json"

cat <<EOF >> /etc/docker/daemon.json
{
  "insecure-registries" : ["192.168.2.11:5000"]
}
EOF


echo "Creating Directories"
mkdir "$(pwd)"/certs

echo "Updating OpenSSL"
cat <<EOF >> /etc/ssl/openssl.cnf
subjectAltName=IP:192.168.2.11
EOF


echo "Creating SSL Cert"
openssl req -newkey rsa:4096 -nodes -sha256 -keyout "$(pwd)"/certs/domain.key -x509 -days 365 -out "$(pwd)"/certs/domain.crt -subj "/C=US/ST=IL/L=Chicago/O=Dis/CN=192.168.2.11"


echo "Enable Registry with Auth"
sudo docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v "$(pwd)"/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2

