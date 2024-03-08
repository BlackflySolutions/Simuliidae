#!/bin/bash
ARG1=$1
# Use my composer to update my civicrm version
if [ -z "$VSITE_CIVICRM_VER" ]; then
  echo 'VSITE_CIVICRM_VER is not set.'
  echo 'You probably want to run this script as root.'
  exit
fi
echo "Preparing CiviCRM Codebase update to $VSITE_CIVICRM_VER using composer."
cd /var/www/standalone
#  sudo -u standalone composer update civicrm/civicrm-core civicrm/civicrm-standalone-8 roundearth/civicrm-composer-plugin --with-dependencies
sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer config extra.enable-patching true
sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer require --no-update civicrm/civicrm-asset-plugin:'~1.1'
sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer require --no-update civicrm/civicrm-core:${VSITE_CIVICRM_VER}
sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer require --no-update civicrm/civicrm-packages:${VSITE_CIVICRM_VER}
sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer require --no-update civicrm/civicrm-standalone-8:${VSITE_CIVICRM_VER}
if  [[ '-y' != $ARG1 ]]; then
  sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer update --dry-run
  while true; do
      read -p "Install this? " yn
      case $yn in
          [Yy]* ) echo 'Installing now ... '; break;;
          [Nn]* ) echo 'Cancelled.'; exit;;
          * ) echo "Please answer y or n.";;
      esac
  done
fi
sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer update
sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer civicrm:publish
cv upgrade:db
chown -R www-data:www-data /var/www/standalone/web/upload/
chown -R www-data:www-data /var/www/standalone/data/
