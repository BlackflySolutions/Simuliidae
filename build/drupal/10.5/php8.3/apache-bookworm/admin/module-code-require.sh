#!/bin/bash
MODULEVER=$1
# Use composer to require a drupal module
if [ -z "$MODULEVER" ]; then
  echo 'Run this script with a single argument of the module machine name, with optional version'
  exit
fi
echo "Preparing to install $MODULEVER code using composer."
cd /var/www/drupal
sudo -u drupal php -d memory_limit=-1 /usr/local/bin/composer require drupal/${MODULEVER}
sudo -E -u www-data drush updatedb -y
sudo -E -u www-data drush cr
