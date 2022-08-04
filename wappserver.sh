##################################################
# Anything wrong? Find me via telegram:@MTP_2018 #
##################################################

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ]; then
  OS=CentOS
  [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
  [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
  [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ]; then
  OS=CentOS
  CentOS_RHEL_version=6
else
  echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
  kill -9 $$
fi

# Detect CPU Threads
THREAD=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)

# Define the Terminal Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# Print Welcome Message
clear
echo "----------------------------------------------------"
echo "  WhatsApp Server Config                            "
echo "  Author: Sardarn84                                 "
echo "----------------------------------------------------"
echo ""

# Repos
if [ ${OS} == CentOS ];then
  cp -rfp /etc/yum.repos.d /etc/yum.repos.d-bac-1
  sed -i "s|^mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/*
  sed -i "s|^#baseurl=http://mirror.centos.org|baseurl=https://y.docker-registry.ir|g" /etc/yum.repos.d/*
fi

# Update And Install Package
if [ ${OS} == CentOS ];then
  sudo yum -y update
  sudo yum -y upgrade
  sudo yum install git -y
  sudo yum install wget -y
fi

# Node Install
if [ ${OS} == CentOS ];then
  curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
  sudo yum clean all && sudo yum makecache fast
  sudo yum install -y gcc-c++ make
  sudo yum install -y nodejs
  sudo yum install -y unzip
  npm install -g nodemon
fi

# Firewalld
if [ ${OS} == CentOS ];then
  yum install firewalld -y
  systemctl enable firewalld
  systemctl start firewalld
  sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
  sudo firewall-cmd --reload
  systemctl status firewalld
fi

# Install Source and Run
if [ ${OS} == CentOS ];then
  wget http://demo-php.ir/whatsapp/WhatsApp-Nodejs.zip
  unzip WhatsApp-Nodejs.zip
  cd WhatsApp-Nodejs

  npm i request
  npm i qrcode-terminal
  npm install forever -g
  
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
  sudo yum localinstall google-chrome-stable_current_x86_64.rpm

  export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
  npm i

  cd node_modules/whatsapp-web.js/src/util
  rm Injected.js
  wget http://demo-php.ir/whatsapp/Injected.js
  cd ../../../../
  
  forever start app.js
fi

# Display Service Information
clear
echo "WhatsApp Server Installation！"
echo ""
