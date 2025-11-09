#!/bin/bash

#-----------------------------------
# Jenkins on Amazon Linux
# Java mandatory install for Jenkins
# Jenkins_Docker_Install_Amazon_Linux.ksh
# https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
# /var/lib/jenkins/secrets/initialAdminPassword
# /tmp/jenkins_docker_java_install_logs_${PID}.txt - Logs
# Author: Krishna Kumar M - https://github.com/krishnakumarkrish
# Version: 1.1
#-----------------------------------

set -e  # Exit immediately if any command fails

PID=$$

# Remove previous logs if they exist
rm -f /tmp/jenkins_docker_java_install_logs_*

# Create a new log file
tmp_jenkins_docker_java_install="/tmp/jenkins_docker_java_install_logs_${PID}.txt"

cd /opt

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Ensure that your software packages are up to date on your instance"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install 
sudo yum update -y | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install 
echo "Docker - Install"  | tee -a $tmp_jenkins_docker_java_install 
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install 
sudo yum install docker -y | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install 
echo "Docker - Start , Status"  | tee -a $tmp_jenkins_docker_java_install 
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install 
sudo systemctl start docker | tee -a $tmp_jenkins_docker_java_install
sudo systemctl status docker | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install 
echo "Docker - Added to ec2-user"  | tee -a $tmp_jenkins_docker_java_install 
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install 
sudo gpasswd -a ec2-user docker | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Add the Jenkins repo"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo 2>&1 | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Import a key file from Jenkins-CI to enable installation from the package"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install		
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key 2>&1 | tee -a $tmp_jenkins_docker_java_install

# Upgrade all installed packages
sudo yum upgrade -y | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Install Java (Amazon Linux 2023)"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo dnf install java-17-amazon-corretto -y | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Install Jenkins"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo yum install jenkins -y | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Enable the Jenkins service to start at boot"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo systemctl enable jenkins | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Start Jenkins as a service"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo systemctl start jenkins | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Docker Jenkins Permission"  | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
sudo usermod -aG docker jenkins | tee -a $tmp_jenkins_docker_java_install

echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
echo "Restart Jenkins"  | tee -a $tmp_jenkins_docker_java_install
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
echo "Please Reboot the Server"  | tee -a $tmp_jenkins_docker_java_install
# sudo reboot | tee -a $tmp_jenkins_docker_java_install
echo "**********************************************************************"  | tee -a $tmp_jenkins_docker_java_install
