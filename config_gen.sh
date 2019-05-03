#!/bin/bash

# Arrays and variables

declare -A host_info
declare -A ssh_info

digit=1

# Functions

confirm(){
  read -ep "Continue adding hosts? (y/n) " choice
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

# Generates keys for all domains given

for host in "${!host_info[@]}"; do
  for user in $(echo "${host_info[$host]}"); do
    read -ep "Name of key for $user@$host? " KEY;
    keypath="$HOME/.ssh/$KEY.key"
    ssh_info[$user@$host]+="$keypath"
    ssh-keygen -t rsa -N "" -f $keypath -q
  done
done

# Generates SSH prompt to auth each key

for identity in "${!ssh_info[@]}"; do
  ssh-copy-id -i ${ssh_info[$identity]} $identity
done

# Generates $HOME/.ssh/config entries for each user

for identity in "${!ssh_info[@]}"; do
  user=${identity%@*}
  host=${identity#*@}
  read -ep "Name of alias for $identity? " ALIAS;
  echo -e "\nHost $ALIAS
  Hostname $host
  User $user
  IdentityFile ${ssh_info[$identity]}"\
  >> $HOME/.ssh/config
done
