print() {
  LSPACE=$(echo $1 | awk '{print length}')
  echo $MSPACE
  echo $LSPACE
 echo -n -e "\e[1m$1${SPACE}\e[0m........"
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


