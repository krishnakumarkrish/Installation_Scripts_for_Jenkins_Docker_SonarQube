#!/bin/bash

#-----------------------------------
# Jenkins on Ubuntu Linux
# Java mandatory install for Jenkins
# Jenkins_Install_Ubuntu_Linux.ksh
# https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
# /var/lib/jenkins/secrets/initialAdminPassword
# /tmp/jenkins_install_logs_${PID}.txt - Logs
# Author: Krishna Kumar M - https://github.com/krishnakumarkrish
# Version: 1.1 (Adapted for Ubuntu)
#-----------------------------------

set -e # Exit immediately if any command fails

PID=$$

# Remove previous logs if they exist
rm -f /tmp/jenkins_install_logs_*

# Create a new log file
tmp_jenkins_install="/tmp/jenkins_install_logs_${PID}.txt"

cd /opt

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Ensure that your software packages are up to date on your instance" | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install
# Update package lists
sudo apt update -y | tee -a $tmp_jenkins_install

---

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Install essential packages: Java 17 and utility tools" | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install
# Install Java 17 (OpenJDK is standard on Ubuntu) and prerequisite tools
sudo apt install fontconfig openjdk-17-jre -y | tee -a $tmp_jenkins_install

---

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Add the Jenkins repository key and source list" | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install
# Download and import the Jenkins GPG key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key 2>&1 | tee -a $tmp_jenkins_install

# Add the Jenkins repository to the source list
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null 2>&1 | tee -a $tmp_jenkins_install

---

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Update package lists again to include Jenkins repo" | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install
sudo apt update -y | tee -a $tmp_jenkins_install

---

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Install Jenkins" | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install
sudo apt install jenkins -y | tee -a $tmp_jenkins_install

# Jenkins service is automatically started and enabled by the 'apt install' on Ubuntu, 
# but we explicitly start it and check status for confirmation.

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Check the status of the Jenkins service" | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install
sudo systemctl status jenkins | tee -a $tmp_jenkins_install

---

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Completed" | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install

echo "**********************************************************************" | tee -a $tmp_jenkins_install
echo "Initial Admin Password Location: /var/lib/jenkins/secrets/initialAdminPassword" | tee -a $tmp_jenkins_install
echo "Please Reboot the Server" | tee -a $tmp_jenkins_install
# sudo reboot | tee -a $tmp_jenkins_install
echo "**********************************************************************" | tee -a $tmp_jenkins_install
