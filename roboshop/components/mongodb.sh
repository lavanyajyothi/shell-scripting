#!/bin/bash
source components/common.sh
print "Download Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
stat $?

print "install mongodb"
yum install -y mongodb-org &>>$LOG
stat $?
print "update mongodb config"
sed -i -e 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>>$LOG
stat $?
print "enable mongodb"
systemctl enable mongod &>>$LOG
stat $?
print "start mongodb"
systemctl start mongod &>>$LOG
stat $?

print "Download Scheme"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG
stat $?
cd /tmp
unzip -o -d /tmp /tmp/mongodb.zip &>>$LOG
stat $?

print "Load Schema"
cd /tmp/mongodb-main
mongo < catalogue.js &>>$LOG
mongo < users.js &>>$LOG
stat $?

