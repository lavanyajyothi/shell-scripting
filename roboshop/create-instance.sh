#!/bin/bash
aws ec2 run-instances --image-id ami-0e4e4b2f188e91845 --instance-type t3.micro --tag-specifications "ResourceType=instance,Tags=[{key=Name,Value=$1}]"