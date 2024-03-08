#!/bin/bash
# Use my composer to update my standalone version
echo "Downloading CiviCRM Codebase using composer."
cd /var/www/standalone
# install civicrm code and do setup if not yet installed
if [ -d "/var/www/standalone/vendor/civicrm" ]; then
  echo "Detected existing CiviCRM codebase, aborted."
else
  sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer require --no-update civicrm/civicrm-core:${VSITE_CIVICRM_VER}
  sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer require --no-update civicrm/civicrm-packages:${VSITE_CIVICRM_VER}
  sudo -u standalone php -d memory_limit=-1 /usr/local/bin/composer update
  echo "CiviCRM codebase installed."
fi
