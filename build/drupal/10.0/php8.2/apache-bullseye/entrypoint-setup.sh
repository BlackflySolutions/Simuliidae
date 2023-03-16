#!/bin/bash
# extended entrypoint to set things up from scratch
/usr/local/bin/initialize.sh
chown www-data /var/www/drupal/web/sites/default
/usr/local/bin/drupal-setup.sh
# run the civi setup script if it exists!
test -x /usr/local/bin/civicrm-setup.sh && $_
# Hand off to the CMD (or quit?)
if test -z "$@"
then
  apache2-foreground
else
  exec "$@"
fi
