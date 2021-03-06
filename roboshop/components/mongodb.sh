#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 | grep print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=MongoDB
COMPONENT=mongodb

print "Download Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
stat $?

print "install MongoDB"
yum install -y mongodb-org &>>$LOG
stat $?

print "Update MongoDB Config"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG
stat $?


print "start MongoDB"
systemctl restart mongod &>>$LOG
stat $?

print "enable MongoDB"
systemctl enable mongod &>>$LOG
stat $?

DOWNLOAD "/tmp"

print "Load Schema"
cd /tmp/mongodb-main
for db in catalogue users ; do
  mongo < $db.js &>>$LOG
done

stat $?


