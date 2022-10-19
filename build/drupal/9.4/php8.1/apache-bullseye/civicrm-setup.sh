#!/bin/bash
# Do initialization of CiviCRM if not yet installed
echo "Installing a new CiviCRM instance."
if [ ! -f /var/www/drupal/web/sites/default/civicrm_settings.php ]; then
  chmod ug+w /var/www/drupal/web/sites/default
  mysql -u root -p$MYSQL_PASSWORD -h vsql  -e "create database if not exists $CIVICRM_DATABASE; grant all on $CIVICRM_DATABASE.* to $MYSQL_USER@'%';"
  sudo -E -u www-data drush -y pm:enable civicrm
  chmod ug-w /var/www/drupal/web/sites/default
  curl -LsS https://download.civicrm.org/cv/cv.phar -o /usr/local/bin/cv
  chmod +x /usr/local/bin/cv
  sudo -E -u www-data drush -y pm:enable civicrmtheme
  # cv api Setting.create userFrameworkResourceURL="[cms.root]/libraries/civicrm/core/"
  echo "CiviCRM setup complete";
else 
  echo "Found existing setup, aborted";
fi
