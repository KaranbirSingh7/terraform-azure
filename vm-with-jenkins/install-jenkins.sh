#!/bin/bash
sudo apt update -y
sudo apt install openjdk-8-jdk -y

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update -y
sudo apt install jenkins -y

sudo ufw allow 8080

# Once the script is ran, open up a web browser > take your public IP address from the Azure VM > Put it in a web browser with port 8080. For example

# Retrieve the initial admin password
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword