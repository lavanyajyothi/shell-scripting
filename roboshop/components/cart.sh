#!/bin/bash

source components/common.sh


MSPACE=$(cat $0 components/common.sh | grep   print | awk -F '"' '{print $2}' | awk '{ print length }' | sort | tail -1)

COMPONENT_NAME=Cart
COMPONENT=cart


NodeJS
CHECK_REDDIS_FROM_APP

