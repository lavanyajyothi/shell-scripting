#!/bin/bash

source components/common.sh

MSPACE=$(cat $0 | grep ^print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Catalogue
COMPONENT=catalogue
NodeJS
CHECK_MONGO_FROM_APP


