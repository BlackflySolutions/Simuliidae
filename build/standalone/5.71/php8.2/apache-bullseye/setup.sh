#!/bin/bash
#chown www-data /var/www/drupal/web/sites/default
#/usr/local/bin/drupal-setup.sh
# run the civi setup script if it exists!
test -x /usr/local/bin/civicrm-setup.sh && $_
