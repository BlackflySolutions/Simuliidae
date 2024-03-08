#!/bin/bash
# Do initialization of CiviCRM if not yet installed
# TODO - use a known admin passwd or save it? Output of cv shows what it is ...
echo "Installing a new CiviCRM instance."
if [ ! -f /var/www/standalone/data/civicrm_settings.php ]; then
  chmod ug+w /var/www/drupal/web/sites/default
  cv core:install --cms-base-url=https://$VSITE_DOMAIN --db="mysql://$MYSQL_USER:$MYSQL_PASSWORD@vsql/$CIVICRM_DATABASE"
  echo "CiviCRM setup complete";
else 
  echo "Found existing setup, aborted";
fi
