#!/bin/bash
# restore sites/default from it's origin backup
RESTORE_DIR="/var/restore/volume/${VSITE}_vsite/files/"
rsync -az $RESTORE_DIR /var/www/html/sites/default/files
chown -R www-data:www-data /var/www/html/sites/default/files
sudo -E -u www-data drush cc all
