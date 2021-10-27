#!/bin/bash
source components/common.sh
print "Installing Nginx"
yum install nginx -y &>>$LOG
stat $?
print "Enabling Nginx"
systemctl enable nginx
stat $?

print "starting Nginx"
systemctl start nginx
stat $?

print "download Html pages"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"&>>$LOG
stat $?

print "Remove old html pages"
rm -rf /usr/share/nginx/html/*
stat $?

print "Extract Frontend archive"
unzip -d /usr/share/nginx/html /tmp/frontend.zip &>>$LOG
stat $?

print "copy files to nginx path"
mv /tmp/frontend-main/static/* /usr/share/nginx/html/.
stat $?

#mv frontend-main/* .
#mv static/* .
#rm -rf frontend-master static README.md
#mv localhost.conf /etc/nginx/default.d/roboshop.conf
#systemctl restart nginx

