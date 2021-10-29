#!/bin/bash

# Reload configuration
source /config.saved

# If there's no SSH host key storage, we can't provide
# SSH services.
if [ "$PHABRICATOR_HOST_KEYS_PATH" == "" ]; then
  echo "PHABRICATOR_HOST_KEYS_PATH is not set; unable to provide SSH access to repositories."
  while [ 0 -eq 0 ]; do
    sleep 10000
  done
  exit 0
fi

# In case if not already present,
# avoid 'Missing privilege separation directory: /run/sshd' error
mkdir -p /run/sshd

# Generate SSH host keys if they aren't already present
if [ ! -f /baked ]; then
  if [ -d $PHABRICATOR_HOST_KEYS_PATH ]; then
    cp -v $PHABRICATOR_HOST_KEYS_PATH/* /etc/ssh/
    #ensure correct file modes of private keys
    chmod 600 /etc/ssh/ssh_host_{dsa_,ecdsa_,ed25519_,,rsa_}key
  fi
  #generate missing keys --> sshd needs sometimes more keys for newer protocols
  if [ ! -f /etc/ssh/ssh_host_rsa_key     ]; then ssh-keygen -f /etc/ssh/ssh_host_rsa_key     -t rsa     -N ''; fi
  if [ ! -f /etc/ssh/ssh_host_dsa_key     ]; then ssh-keygen -f /etc/ssh/ssh_host_dsa_key     -t dsa     -N ''; fi
  if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''; fi

  mkdir -pv $PHABRICATOR_HOST_KEYS_PATH
  #copy only when the file does not exist
  cp -vn /etc/ssh/ssh_host_{dsa_,ecdsa_,ed25519_,,rsa_}key{,.pub} $PHABRICATOR_HOST_KEYS_PATH/
fi

if [ ! -f /is-baking ]; then
  # Run SSHD
  /usr/sbin/sshd -f /etc/phabricator-ssh/sshd_config.phabricator

  set +e
  set +x

  PIDFILE=/run/sshd-phabricator.pid

  COUNT=0
  while [ ! -f $PIDFILE ]; do
    echo "Waiting for $PIDFILE to appear..."
    sleep 1
    COUNT=$[$COUNT+1]
    if [ $COUNT -gt 60 ]; then
      exit 1
    fi
  done

  PID=$(cat $PIDFILE)
  while s=`ps -p $PID -o s=` && [[ "$s" && "$s" != 'Z' ]]; do
    sleep 1
  done

  exit 1  # Supervisord will restart.
fi

