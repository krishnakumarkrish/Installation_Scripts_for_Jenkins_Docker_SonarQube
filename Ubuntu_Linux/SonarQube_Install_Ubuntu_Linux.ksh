#!/bin/bash

#-----------------------------------
# SonarQube on Ubuntu Linux
# Java mandatory install for SonarQube
# SonarQube_Install_Ubuntu_Linux.ksh
# /tmp/sonarqube_install_logs_${PID}.txt - Logs
# Author: Krishna Kumar M - https://github.com/krishnakumarkrish (Modified for Ubuntu)
# Version: 1.2
#-----------------------------------

set -e # Exit immediately if any command fails

PID=$$

# Remove previous logs if they exist
rm -f /tmp/sonarqube_install_logs_*

# Create a new log file
tmp_sonarqube_install="/tmp/sonarqube_install_logs_${PID}.txt"

cd /opt

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Updating package lists" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
sudo apt update -y | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Install Java (OpenJDK 17 is generally preferred for Ubuntu)" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
# Installing OpenJDK 17. The 'default-jdk' often points to the latest stable version, 
# but for a specific requirement like SonarQube 8.9 LTS, OpenJDK 17 is appropriate.
sudo apt install openjdk-17-jre-headless -y | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Install - wget unzip" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
# 'wget' and 'unzip' are typically available, but we ensure they are installed using apt
sudo apt install wget unzip -y | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Download SonarQube - 8.9.10.61524" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Unzip SonarQube - 8.9.10.61524" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
sudo unzip sonarqube-8.9.10.61524.zip | tee -a $tmp_sonarqube_install


echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Create User - sonar" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
# The useradd command is the same on Ubuntu
sudo useradd sonar | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Change user (root to sonar) for sonarqube-8.9.10.61524 folder" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
sudo chown -R sonar:sonar /opt/sonarqube-8.9.10.61524 | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Change Permission 775 to sonarqube-8.9.10.61524 folder" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install		
sudo chmod -R 775 /opt/sonarqube-8.9.10.61524 | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Start SonarQube" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
sudo -u sonar /opt/sonarqube-8.9.10.61524/bin/linux-x86-64/sonar.sh start | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Status SonarQube" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
sudo -u sonar /opt/sonarqube-8.9.10.61524/bin/linux-x86-64/sonar.sh status | tee -a $tmp_sonarqube_install


echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Completed" | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install

echo "**********************************************************************" | tee -a $tmp_sonarqube_install
echo "Please Reboot the Server" | tee -a $tmp_sonarqube_install
# sudo reboot | tee -a $tmp_sonarqube_install
echo "**********************************************************************" | tee -a $tmp_sonarqube_install
