#!/bin/bash

yum install wget rsync policycoreutils-python-utils -y 
wget https://dev.mysql.com/get/mysql80-community-release-el8-9.noarch.rpm
yum install mysql80-community-release-el8-9.noarch.rpm -y 

yum module disable mysql
yum install mysql-community-server -y 



dnf -y install telnet


# Fresh data directory 

/usr/sbin/mysqld --initialize-insecure --user=mysql