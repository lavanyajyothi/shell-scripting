#!/bin/bash

function abc(){
  echo i am a function abc
  echo a in function= $a
  b=20
  return 20
  echo first argument in function= $1
  }
xyz() {
  echo i am a function xyz
}
a=10
abc $1
echo exit status of abc = $?
echo b in main programe=$b
xyz
echo first argument in main program = $1





