#!/bin/bash

source components/common.sh

cat $0 | grep ^print | awk -f '"' '{print $2}'
exit
print "install NodeJS"
yum install nodejs make gcc-c++ -y &>>$LOG
stat $?

print "Add Roboshop User"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
  echo user roboshop already exist &>>$LOG
else
  useradd roboshop &>>$LOG
fi
stat $?

print "Download Catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
stat $?

print "Remove Old Content"
rm -rf /home/roboshop/catalogue
stat $?

print "Extract Catalogue"
unzip -o -d /home/roboshop /tmp/catalogue.zip &>>$LOG
stat $?

print "Copy Content"
mv /home/roboshop/catalogue-main /home/roboshop/catalogue
stat $?

print "Install NodeJS Dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>$LOG
stat $?

print "Fix App Permissions"
chown -R roboshop:roboshop /home/roboshop
stat $?

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