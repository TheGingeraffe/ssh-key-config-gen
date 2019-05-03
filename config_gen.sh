#!/bin/bash

# Array which stores hosts and users for re-use

declare -A host_info

# Confirmation function

confirm(){
  read -p "Continue (y/n)?" choice
  case "$choice" in
    y|Y ) echo "yes";;
    n|N ) echo "no";;
    * ) echo "invalid";;
  esac
}

# Sets the stage

digit=1

read -ep "Please enter hostname #$digit: " HOST;
read -ep "Please enter all users for hostname #$digit delimited by spaces: " USER;

while true; do
  answer=$(confirm)
  if [[ $answer == "no" ]]; then
    break
  elif [[ $answer == "yes" ]]; then
    digit=$((digit+1))
    read -ep "Please enter hostname #$digit: " HOST;
    read -ep "Please enter all users for hostname #$digit delimited by spaces: " USER;
    continue
  else
    echo "Input not understood, please use [Yy/Nn]"
    continue
  fi
done


# TODO Generate keys for all domains given (from file OR stdin)



# TODO Generate SSH prompt to auth each key



# TODO Generate ~/.ssh/config entries for each host
