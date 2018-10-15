#!/bin/bash
echo $@ >> /tmp/file.txt
sudo apt-get update -y
sudo apt-get install openjdk-8-jre openjdk-8-jre-headless openjdk-8-jdk -y
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]
do
        sleep 2
done
until sudo echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"$1\", \"$2\")" | java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` groovy =; do
                sleep 2s
        done
sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin -restart Git JUnit Gradle GitHub
sudo sed -i s/NEW/RUNNING/g /var/lib/jenkins/config.xml
until echo "<com.cloudbees.plugins.credentials.domains.Domain>
    <name>GithubCredentials</name>
</com.cloudbees.plugins.credentials.domains.Domain>" | sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` create-credentials-domain-by-xml "SystemCredentialsProvider::SystemContextResolver::jenkins"
do
sleep 2s
done
sudo echo "<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
               <scope>GLOBAL</scope>
                 <id>$3</id>
                   <description>Github user for RW operations</description>
                     <username>$4</username>
                       <password>$5</password>
                       </com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>"  | sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` create-credentials-by-xml "SystemCredentialsProvider::SystemContextResolver::jenkins" GithubCredentials
#sudo service jenkins restart
