#!/usr/bin/env bash

echo "Installing Docker"

 curl -fsSL get.docker.com | CHANNEL=stable sh
 sudo apt install docker-ce
 sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "Enable Docker Service"

systemctl status docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service 

sudo usermod -aG docker $(whoami)

echo "Restart Docker Service"
sudo systemctl restart docker

