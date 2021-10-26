read -p "enter user name : " username

if [ "$username" == "root" ]
then
  echo "Hey u are root user"
else
  echo "you are not root user"
fi