#!/bin/bash
sudo apt-get update -y
sudo apt-get install nodejs -y
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
a=$(id -g)
sudo newgrp docker
sudo newgrp $a


