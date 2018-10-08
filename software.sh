#!/bin/bash
sudo apt-get update -y
sudo apt-get install nodejs -y
sudo docker --version > /tmp/test.txt
sudo docker swarm init >> /var/log/user-data.log                        
sudo sed -i '/ExecStart/c\ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:4243' /lib/systemd/system/docker.service                       
sudo systemctl daemon-reload
sudo service docker restart
sudo curl http://localhost:4243/version >> /var/log/user-data.log
docker network create -d overlay devone >> /var/log/user-data.log
sudo docker swarm join-token worker >> /home/$1/init.sh
sed -i '1d' /home/$1/init.sh
