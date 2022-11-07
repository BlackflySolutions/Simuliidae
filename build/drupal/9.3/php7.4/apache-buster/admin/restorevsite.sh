#!/bin/bash
# restore sites/default from it's origin backup
RESTORE_DIR="/var/restore/volume/${VSITE}_vsite/"
rsync -az $RESTORE_DIR /var/www/drupal/web/sites/default
chown -R www-data:www-data /var/www/drupal/web/sites/default/files
rm -R /var/www/drupal/web/sites/default/files/civicrm/templates_c/*
sudo -E -u www-data drush cr
