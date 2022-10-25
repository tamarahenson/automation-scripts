#!/usr/bin/env bash

echo "Installing Docker"

 curl -fsSL get.docker.com | CHANNEL=stable sh
 sudo apt install docker-ce
 sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "Enable Docker Service"

 systemctl status docker
 sudo systemctl enable docker.service
 sudo systemctl enable containerd.service 

echo "Update docker daemon.json to use Docker Registry"

cat <<EOF >> /etc/docker/daemon.json
{
  "insecure-registries" : ["192.168.2.11:5000"]
}
EOF

echo "Restart Docker Service"

sudo systemctl restart docker

