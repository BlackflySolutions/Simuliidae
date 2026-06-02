#!/bin/bash
if [[ ! -z "$VSITE_SSH_USER" ]]; then
  mkdir /root/.ssh/
  cp /home/${VSITE_SSH_USER}/.ssh/hosted_id_rsa.pub /root/.ssh/authorized_keys
  service ssh start
fi
