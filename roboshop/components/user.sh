
source components/common.sh

MSPACE=$(cat $0 | grep ^print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)
COMPONENT_NAME=User
COMPONENT=user
NodeJS


sleep 5

print "checking DB connections from app"
STAT=$(curl -s localhost:8080/health | jq .mongo)
echo status = $STAT
if [ $STAT == "true" ]; then
  stat 0
else
  stat 1
fi