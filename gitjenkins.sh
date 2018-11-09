#!/bin/bash
echo $@ >> /tmp/file.txt
sudo apt-get update -y
sudo apt-get install openjdk-8-jre openjdk-8-jre-headless openjdk-8-jdk -y
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce -y
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]
do
        sleep 2
done
until sudo echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"$1\", \"$2\")" | java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` groovy =; do
                sleep 2s
        done
sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth $1:$2 install-plugin -restart github-branch-source Git JUnit Gradle GitHub
sudo sed -i s/NEW/RUNNING/g /var/lib/jenkins/config.xml
