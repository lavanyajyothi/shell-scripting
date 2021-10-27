#!/bin/bash
source components/common.sh
print "Installing Nginx"
yum install nginx -y &>>$LOG
stat $?
print "Enabling Nginx"
systemctl enable nginx &>>$LOG
stat $?

print "starting Nginx"
systemctl start nginx &>>$LOG
stat $?

print "download Html pages"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"&>>$LOG
stat $?

print "Remove old html pages"
rm -rf /usr/share/nginx/html/* &>>$LOG
stat $?

print "Extract Frontend archive"
unzip -o -d /tmp /tmp/frontend.zip &>>$LOG
stat $?

print "copy files to nginx path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/.
stat $?

print "copy nginx roboshop config file"
cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

print "enabling nginx"
systemctl enable nginx &>>LOG
stat $?

print "starting nginx"
systemctl restart nginx &>>$LOG
stat $?

