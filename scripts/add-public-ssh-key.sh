#!/bin/bash
user_public_key=$1
if [ "$user_public_key" != "None" ] ; then
  if [ ! -f ${HOME}/.ssh/authorized_keys ]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ${HOME}/.ssh/authorized_keys
  fi
  echo "$user_public_key" >> $HOME/.ssh/authorized_keys
  chmod 600 $HOME/.ssh/authorized_keys

  if [[ $? -ne 0 ]]; then
    echo "An error occured."
    exit 1
  else
    echo "The operation has been executed successfully."
  fi
fi