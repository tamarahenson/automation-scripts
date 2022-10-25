#!/usr/bin/env bash

echo "Installing Podman"

sudo yum install -y podman
sudo systemctl enable podman.socket
sudo systemctl start podman.socket

echo "Podman Installed!"
