#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 | grep ^print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

print "Install Reddis Repos"
yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG
stat $?

print "Enable Redis Repos"
yum-config-manager --enable remi &>>$LOG
stat $?

print "Install Reddis"
yum install redis -y &>>$LOG
stat $?

print "Update Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
stat $?

print "Start Reddis Database"
systemctl enable redis &>>$LOG && systemctl restart redis &>>$LOG
stat $?
