print() {
  LSPACE=$(echo $1 | awk '{print length}')
  SPACE=$(($MSPACE-$LSPACE))
  SPACES=""
  while [ $SPACE -gt 0 ]; do
    SPACES="$SPACES$(echo ' ')"
    SPACE=$(($SPACE-1))
  done
 echo -n -e "\e[1m$1${SPACES}\e[0m  ..."
 echo -e "\n\e[36m#######################$1#######################\e[0m" >>$LOG
}

stat(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32msuccess\e[0m"
  else
    echo -e "\e[1;31mfailure\e[0m"
    echo -e "\e[1;36mscript failed and check the detailed log in $LOG file\e[0m"
    exit 1
  fi
}
LOG=/tmp/roboshop.log
rm -f $LOG


NodeJS(){
  print "install NodeJS"
  yum install nodejs make gcc-c++ -y &>>$LOG
  stat $?

  print "Download $COMPONENT_NAME"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  stat $?

   print "Extract $COMPONENT_NAME"
   unzip -o -d /home/roboshop /tmp/${COMPONENT}.zip &>>$LOG
   stat $?
   if [ "$1" == "/home/roboshop" ]; then
       print "Remove Old Content"
        rm -rf /home/roboshop/${COMPONENT}
        stat $?
        print "Copy Content"
          mv /home/roboshop/${COMPONENT}-main /home/roboshop/${COMPONENT}
          stat $?
    fi
  }
ROBOSHOP_USER(){
   print "Add Roboshop "
    id roboshop &>>$LOG
    if [ $? -eq 0 ]; then
      echo user roboshop already exist &>>$LOG
    else
      useradd roboshop &>>$LOG
    fi
    stat $?
SYSTEMD(){
  print "Fix App Permissions"
    chown -R roboshop:roboshop /home/roboshop
    stat $?
}

  print "Update DNS records in SystemD config"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/reddis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
  stat $?

  print "Copy SystemD file"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  stat $?
  print "start $COMPONENT_NAME service"
  systemctl daemon-reload &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG
  stat $?

PYTHON(){
  print "Install Pyhton 3"
  yum install python 36 gcc python3-devel -y &>>$LOG
  stat $?

  ROBOSHOP_USER
  DOWNLOAD "/home/roboshop"

  print "Install the dependencies"
  cd /home/roboshop/${COMPONENT}
  pip3 install -r requirements.txt &>>$LOG
  stat $?

  SYSTEMD
}
  MAVEN() {
    print "Install Maven"
    yum install maven -y &>>$LOG
    stat $
  }

  ROBOSHOP_USER
  DOWNLOAD "/home/roboshop"

  print "Make Maven Package"
  cd /home/roboshop/${COMPONENT}
  mvn clean package &>>$LOG && mv target/shipping-1.0.jar shipping.jar &>>$LOG
  stat $?

  SYSTEMD
}
NodeJS() {
  print "Install nodejs"
  yum install nodejs make gcc-c++ -y &>>$LOG
  stat $?

  ROBOSHOP_USER

  DOWNLOAD "/home/roboshop"

  print "Install NodeJS Dependencies"
  cd /home/roboshop/${COMPONENT}
  npm install --unsafe-perm &>>$LOG
  stat $?

  SYSTEMD

}

CHECK_MONGO_FROM_APP(){
  print "checking DB connections from app"
  sleep 5
  STAT=$(curl -s localhost:8080/health |  jq .mongo)
  if [ "$STAT" == "true" ]; then
    stat 0
  else
    stat 1
  fi
}
CHECK_REDDIS_FROM_APP(){
  print "checking DB connections from app"
  sleep 5
  STAT=$(curl -s localhost:8080/health |  jq .redis)
  echo status = $STAT
  if [ "$STAT" == "true" ]; then
    stat 0
  else
    stat 1
  fi
}