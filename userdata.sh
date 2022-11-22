#!/bin/bash

# Define hostname
HN=backend.amaldeep.tech

# Define MySQL root password
DB_ROOT_PASS=abc@123

# yum update
yum update -y

# set hostname
hostnamectl set-hostname backend.amaldeep.tech

# install mariadb
yum install mariadb-server -y 

# enable mariadb service
systemctl enable mariadb.service
systemctl restart mariadb.service

# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('$DB_ROOT_PASS') WHERE User = 'root'"

# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"

# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"

# Kill off the demo database
mysql -e "DROP DATABASE test"

# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"

#Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param
