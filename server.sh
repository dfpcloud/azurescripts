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
sudo usermod -aG docker $1
sudo docker -v
while [ $? != 0 ]
do
          echo $?
          sleep 2
          echo "check it once again"
          sudo docker -v
done
sudo docker swarm init                        
sudo sed -i '/ExecStart/c\ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:4243' /lib/systemd/system/docker.service                       
sudo systemctl daemon-reload
sudo service docker restart
sudo curl http://localhost:4243/version >> /var/log/user-data.log
docker network create -d overlay devone >> /var/log/user-data.log
sudo docker swarm join-token worker >> /home/$1/init.sh
sed -i '1d' /home/$1/init.sh
