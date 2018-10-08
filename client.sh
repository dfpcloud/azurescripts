#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'
sudo apt-get update
sudo apt-get install -y docker-ce
sudo apt install sshpass
sshpass -p $2 scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $1@$3:/tmp/file.txt /home/$1/siba.txt
sshpass -p $2 scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $1@$3:/home/$1/init.sh /home/$1/init.sh
cd /home/$1
sudo chmod 777 init.sh 
sudo ./init.sh 
