#!/bin/bash
/usr/local/bin/initialize.sh
if [[ ! -z "$VSITE_SSH_USER" ]]; then
  mkdir /root/.ssh/
  cp /home/${VSITE_SSH_USER}/.ssh/hosted_id_rsa.pub /root/.ssh/authorized_keys
  env | grep _ >> /etc/environment
fi
# Hand off to the CMD
if test -z "$@"
then
  exec /usr/sbin/sshd -D -e
else
  exec "$@"
fi
