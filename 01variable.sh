#!/bin/bash

a=10
b=abc
echo value of a= $a
echo value of b=$b

echo fine
x=10
y=20
echo $xX$y =200
echo ${x}x${y} =200
Date=$(date +%F)
echo  Good Morning welcome today date is $Date

#arthamatic substitution
Add = $((2+3+5*7/2-5))
echo added = $Add
