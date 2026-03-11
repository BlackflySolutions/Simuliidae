#!/bin/bash
MODULENAME=$1
# Use composer to require a drupal module
if [ -z "$MODULENAME" ]; then
  echo 'Run this script with a single argument of the module machine name'
  exit
fi
echo "Preparing to install $MODULENAME code using composer."
cd /var/www/drupal
sudo -u drupal php -d memory_limit=-1 /usr/local/bin/composer require --no-update drupal/${MODULENAME} --update-with-all-dependencies
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
sudo -E -u www-data drush updatedb
sudo -E -u www-data drush cr
