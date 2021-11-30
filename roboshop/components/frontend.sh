#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep ^print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)


print "Installing Nginx"
yum install nginx -y &>>$LOG
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
print "Update Nginx Config file"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e 'payment/ s/localhost/payment.roboshop.interal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>$LOG
stat $?


print "enabling nginx"
systemctl enable nginx &>>LOG
stat $?

print "starting nginx"
systemctl restart nginx &>>$LOG
stat $?

