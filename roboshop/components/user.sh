
source components/common.sh

MSPACE=$(cat $0 components/common.sh | grep print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)
COMPONENT_NAME=User
COMPONENT=user
NodeJS
CHECK_MONGO_FROM_APP



