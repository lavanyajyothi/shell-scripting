#!/bin/bash

source components/common.sh
print "install nodejs"
yum install nodejs make gcc-c++ -y &>>$LOG
stat $?

print "Add Roboshop User"
useradd roboshop &>>$LOG
stat $?

print "Download Catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
stat $?

print "Old Content"
rm -rf /home/roboshop/catalogue
stat $?

print "Extract Catalogue"
$ unzip -o -d /home/roboshop /tmp/catalogue.zip
stat $?
#$ mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install


# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue