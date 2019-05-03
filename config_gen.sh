#!/bin/bash

# Arrays and variables

declare -A host_info

digit=1

# Functions

confirm(){
  read -ep "Continue (y/n)? " choice
  case "$choice" in
    y|Y ) echo "yes";;
    n|N ) echo "no";;
    * ) echo "invalid";;
  esac
}

get_host(){
  read -ep "Please enter hostname #$digit: " HOST;
}

get_users(){
  read -ep "Please enter all users for hostname #$digit delimited by spaces: " USERS;
}
 
# Captures host and user information, then associates them in the host_info array

get_host
get_users

host_info[$HOST]+="$USERS"

while true; do
  answer=$(confirm)
  if [[ $answer == "no" ]]; then
    break
  elif [[ $answer == "yes" ]]; then
    digit=$((digit+1))
    get_host
    get_users
    host_info[$HOST]+="$USERS"
    continue
  else
    echo "Input not understood, please use [Yy/Nn]"
    continue
  fi
done

# Test that prints array

#for i in "${!host_info[@]}"; do
# echo "${i} ${host_info[$i]}"
#done


# TODO Generate keys for all domains given (from file OR stdin)

for host in "${!host_info[@]}"; do
  for user in $(echo "${host_info[$host]}"); do
    read -ep "Name of key for $user@$host? " KEY;
    ssh-keygen -t rsa -N "" -f $HOME/.ssh/$KEY.key -q
  done
done

# TODO Generate SSH prompt to auth each key



# TODO Generate ~/.ssh/config entries for each host
