#!/bin/bash
# setup a .drush folder for my www-data user
if [ ! -d "/var/www/.drush" ]; then
  mkdir /var/www/.drush
  chown www-data:www-data /var/www/.drush
  sudo -E -u www-data drush -y @none dl --destination=/var/www/.drush registry_rebuild-7.x
fi
# if I have a settings files, just run the updatedb and wait for further attention in bash
#  cd /var/www/html/sites/default
# sudo -E -u www-data drush updatedb
# echo "Site is ready at https://${VSITE_DOMAIN}"
#echo "Login using the following url"
# drush uli
if [[ ! -z "$VSITE_SSH_USER" ]]; then
  service ssh start
  useradd -u 2001 $VSITE_SSH_USER
  cp /home/${VSITE_SSH_USER}/.ssh/hosted_id_rsa.pub /home/${VSITE_SSH_USER}/.ssh/authorized_keys
  chown $VSITE_SSH_USER:$VSITE_SSH_USER /home/${VSITE_SSH_USER}/.ssh
  chown $VSITE_SSH_USER:$VSITE_SSH_USER /home/${VSITE_SSH_USER}/.ssh/authorized_keys
  echo "%${VSITE_SSH_USER}      ALL=(ALL) NOPASSWD:ALL" >  /etc/sudoers.d/${VSITE_SSH_USER}
  # and now a crazy thing so that this user gets the environment variables from the uid = 1
  xargs -0 bash -c 'printf "export %q\n" "$@"' -- < /proc/1/environ > /home/${VSITE_SSH_USER}/.profile
fi
