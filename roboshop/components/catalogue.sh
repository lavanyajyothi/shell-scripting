#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 | grep ^print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Catalogue
COMPONENT=catalogue
NodeJS

print "Update DNS records in SystemD config"
sed -i -e"s/MONGO_DNSNAME/mongodb.roboshop.internal/" /home/roboshop/catalogue/systemd.service &>>$LOG
stat $?
print "Copy SystemD file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
stat $?
print "start catalogue service"
systemctl daemon-reload &>>$LOG && systemctl restart catalogue &>>$LOG && systemctl enable catalogue &>>$LOG
stat $?

sleep 5

print "checking DB connections from app"
STAT=$(curl -s localhost:8080/health | jq .mongo)
echo status = $STAT
if [ $STAT == "true" ]; then
  stat 0
else
  stat 1
fi