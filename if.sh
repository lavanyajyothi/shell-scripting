read -p "enter user name : " username

if [ "$username" == "root" ]
then
  echo "Hey u are root user"
else
  echo "you are not root user"
fi

if [$UId -eq 0 ]
then
  echo "you are root user"
else
  echo"you r nor root user"
fi