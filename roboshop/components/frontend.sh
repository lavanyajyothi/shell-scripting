#!/bin/bash
print(){
  echo -n -e "\e[1m$1\e[0m........"
  echo -e "\n\e[36m#######################$1#######################\e[0m" >>$LOG
}
stat(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32msuccess\e[0m"
  else
    echo -e "\e[1;32mfailure\e[0m"
    echo -e "\e[1;36mscript failed and check the detailed log in $LOG file"
    exit 1
  fi
}
LOG=/tmp/roboshop.log
rm -f $LOG
print "Installing Nginx"
yum install nginxxx -y &>>$LOG
stat $?
print "Enabling Nginx"
systemctl enable nginx
stat $?

print "starting Nginx"
systemctl start nginx
stat $?

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

