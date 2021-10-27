#!/bin/bash

source components/common.sh
print "install nodejs"
yum install nodejs make gcc-c++ -y &>>$LOG
stat $?

print "Add Roboshop User"
id roboshop &>>$LOG
if [$? -eq 0 ]; then
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
unzip -o -d /home/roboshop /tmp/catalogue.zip
stat $?

print "Copy Content"
mv /home/roboshopcatalogue-main /home/roboshop/catalogue
stat $?

print "Install NodeJS Dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>$LOG
stat $?

print "Fix App Permissions"
chown -R roboshop:roboshop /home/roboshop
stat $?

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue