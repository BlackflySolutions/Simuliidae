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
