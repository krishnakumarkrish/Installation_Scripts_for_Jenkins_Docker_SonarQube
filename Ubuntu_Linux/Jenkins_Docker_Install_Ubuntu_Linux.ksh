#!/bin/bash

#-----------------------------------
# Jenkins on Ubuntu Linux
# Java mandatory install for Jenkins
# Jenkins_Docker_Install_Ubuntu_Linux.ksh
# Based on: https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
# /var/lib/jenkins/secrets/initialAdminPassword
# /tmp/jenkins_docker_java_install_logs_${PID}.txt - Logs
# Author: Krishna Kumar M - https://github.com/krishnakumarkrish
# Version: 1.1 
#-----------------------------------

set -e  # Exit immediately if any command fails

PID=$$
CURRENT_USER=$(whoami)

# Remove previous logs if they exist
rm -f /tmp/jenkins_docker_java_install_logs_*

# Create a new log file
tmp_jenkins_docker_java_install="/tmp/jenkins_docker_java_install_logs_${PID}.txt"

cd /opt

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Ensure that your software packages are up to date on your instance"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Ubuntu uses apt for updates
sudo apt update -y | tee -a $tmp_jenkins_docker_java_install

# --- Docker Installation ---
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Docker - Install dependencies"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Install packages to allow apt to use a repository over HTTPS
sudo apt install -y ca-certificates curl gnupg lsb-release | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Docker - Add Docker's official GPG key and repository"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings | tee -a $tmp_jenkins_docker_java_install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg | tee -a $tmp_jenkins_docker_java_install
# Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Docker - Install"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Docker - Start , Status (Note: Docker is usually started automatically after install)"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo systemctl enable docker | tee -a $tmp_jenkins_docker_java_install
sudo systemctl start docker | tee -a $tmp_jenkins_docker_java_install
sudo systemctl status docker | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Docker - Added to current user ($CURRENT_USER)"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Add current user to docker group (e.g., ubuntu, not ec2-user)
sudo usermod -aG docker $CURRENT_USER | tee -a $tmp_jenkins_docker_java_install


# --- Jenkins Installation ---

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Install Java 17 (Required for modern Jenkins versions)"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Install default OpenJDK 17
sudo apt install -y openjdk-17-jdk | tee -a $tmp_jenkins_docker_java_install


echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Add the Jenkins repo"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Download and add the Jenkins GPG key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add the Jenkins repository to the system's sources list
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package list again to include the new repository
sudo apt update -y | tee -a $tmp_jenkins_docker_java_install


echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Install Jenkins"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Install Jenkins
sudo apt install jenkins -y | tee -a $tmp_jenkins_docker_java_install


echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Enable and Start Jenkins as a service"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# Enable and start Jenkins (It's usually started after install, but explicit commands are good)
sudo systemctl enable jenkins | tee -a $tmp_jenkins_docker_java_install
sudo systemctl start jenkins | tee -a $tmp_jenkins_docker_java_install


echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Docker Jenkins Permission (Add jenkins user to docker group)"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
# The user for Jenkins is 'jenkins' on Ubuntu
sudo usermod -aG docker jenkins | tee -a $tmp_jenkins_docker_java_install


echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Restart Jenkins (for Docker group membership to take effect)"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo systemctl restart jenkins | tee -a $tmp_jenkins_docker_java_install


echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Check the status of the Jenkins service"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo systemctl status jenkins | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Completed"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Please Reboot the Server or log out/log back in for current user's docker permission to take effect."  | tee -a $tmp_jenkins_docker_java_install
# sudo reboot | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
