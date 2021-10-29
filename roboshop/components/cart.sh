#!/bin/bash

source components/common.sh


MSPACE=$(cat $0 components/common.sh | grep   print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Cart
COMPONENT=cart

NodeJS

CHECK_REDIS_FROM_APP(){
  print "checking DB connections from app"
  sleep 5
  STAT=$(curl -s localhost:8080/health |  jq .redis)
  echo status = $STAT
  if [ $STAT == "true" ]; then
    stat 0
  else
    stat 1
  fi
}


