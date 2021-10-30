#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 | grep ^print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=MySQL
COMPONENT=mysql

print "Setup MySQL repo"
 curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
 stat $?

print "install Mariadb Service"
yum remove mariadb-libs -y &>>$LOG && yum install mysql-community-server -y &>>$LOG
stat $?

print "Start MySQL"
systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
stat $?

DEFAULT_PASSWORD=$(grep 'temporary passwoord' /var/log/mysql.log | awk '{print $NF}')
NEW_PASSWORD="RoboShop@1"

echo 'show databases;' | mysql -uroot -p"${NEW_PASSWORD}" &>>$LOG
if [ $? -ne 0 ]; then
  print "Changing the Default Password"
  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_PASSWORD}';\runinstall plugin validate_password;" >/tmp/pass.sql
  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>$LOG
  stat $?
fi

#Now a default root password will be generated and given in the log file.
# grep temp /var/log/mysqld.log

#Next, We need to change the default root password in order to start using the database service.
# mysql_secure_installation

#You can check the new password working or not using the following command.

# mysql -u root -p

#Run the following SQL commands to remove the password policy.
#> uninstall plugin validate_password;
#Setup Needed for Application.
#As per the architecture diagram, MySQL is needed by

#Shipping Service
#So we need to load that schema into the database, So those applications will detect them and run accordingly.

#To download schema, Use the following command

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#Load the schema for Services.

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql