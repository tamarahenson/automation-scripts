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

