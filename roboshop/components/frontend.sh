#!/bin/bash
print(){
  echo -e "\e[1m$1\e[0m"
  echo -e "\n\e[36m#######################$1#######################\e[0m" >>$LOG
}
LOG=/tmp/roboshop.log
rm -f $LOG
print "Installing Nginx"
yum install nginx -y &>>$LOG
if [ $? -eq 0 ]; then
  echo -e "\n[1:32msuccess\e[0m"
else
  echo -e "\n[1:32mfailure\e[0m"
fi

print "Enabling Nginx"
systemctl enable nginx
print "starting Nginx"
systemctl start nginx

exit
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
# Deploy in Nginx Default Location.

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
systemctl restart nginx

