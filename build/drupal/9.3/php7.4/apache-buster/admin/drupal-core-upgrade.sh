#!/bin/bash
ARG1=$1
# Use my composer to update my drupal version
if [ -z "$VSITE_DRUPAL_VER" ]; then
  echo 'VSITE_DRUPAL_VER is not set.'
  echo 'You probably want to run this script as root.'
  exit
fi
echo "Preparing Drupal core codebase update to $VSITE_DRUPAL_VER using composer."
cd /var/www/drupal
sudo -u drupal php -d memory_limit=-1 /usr/local/bin/composer require --no-update drupal/core-recommended:${VSITE_DRUPAL_VER} --update-with-all-dependencies
# sudo -u drupal composer update drupal/core drupal/core-* --with-all-dependencies
# sudo -u drupal composer update drupal/core-recommended --with-dependencies
if  [[ '-y' != $ARG1 ]]; then
  sudo -u drupal php -d memory_limit=-1 /usr/local/bin/composer update --dry-run
  while true; do
      read -p "Install this? " yn
      case $yn in
          [Yy]* ) echo 'Installing now ... '; break;;
          [Nn]* ) echo 'Cancelled.'; exit;;
          * ) echo "Please answer y or n.";;
      esac
  done
fi
sudo -u drupal php -d memory_limit=-1 /usr/local/bin/composer update
sudo -E -u www-data drush updatedb -y
sudo -E -u www-data drush cr
