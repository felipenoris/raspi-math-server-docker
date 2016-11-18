#!/bin/bash

#
# Run this script as root
#

apt-get update
apt-get -y install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
apt-get update

# Checks if repo was configured correctly
# Something if wrong if the result is "N: Unable to locate package docker-engine"
apt-cache policy docker-engine

apt-get -y install docker-engine
service docker start

# Optional: Add your user to docker group
# sudo usermod -aG docker $USER
