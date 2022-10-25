#!/bin/bash
# Use my drush to do a standard Drupal install, if no settings file exists
if [ ! -f /var/www/html/sites/default/settings.php ]; then
  /usr/local/bin/wait-for-it.sh vsql:3306
  cd /var/www/html/sites/default
#  echo "user: ${MYSQL_USER}";
#  echo "db: ${DRUPAL_DATABASE}";
#  echo "admin name: ${VSITE_ADMIN_NAME}";
#  echo "admin email: ${VSITE_ADMIN_EMAIL}";
#  echo "site mail: ${VSITE}@civicrm.ca";
  cp /usr/local/src/settings.php default.settings.php
  # this will destroy any existing db, should I check first?
  cd /var/www/html
  sudo -E -u www-data drush site-install minimal \
   --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@vsql/$DRUPAL_DATABASE" \
   --yes \
   --site-name=$VSITE_NAME \
   --site-mail=${VSITE}@civicrm.ca \
   --account-name=$VSITE_ADMIN \
   --account-mail=${VSITE}@civicrm.ca \
   --db-su=root \
   --db-su-pw=$MYSQL_ROOT_PASSWORD 
  sudo -E -u www-data drush -y pm-enable features admin_menu varnish git_deploy jquery_update bootstrap
  sudo -E -u www-data drush -y pm-enable ${VSITE_ADMIN_THEME:-seven}
  sudo -E -u www-data drush -y vset admin_theme ${VSITE_THEME:-seven}
# allow for initial setup using a site feature, defaults to ctools
  sudo -E -u www-data drush -y pm-enable ${VSITE_FEATURE:-ctools}
  sudo -E -u www-data drush sql-query "UPDATE block SET status = 0 WHERE NOT(module = 'system' AND (delta = 'main' OR delta = 'help'))"
  echo "Site Installation Completed"
  # TODO: report back to root that I have completed!
else
# if I have a settings files, just run the updatedb and wait for further attention in bash
  cd /var/www/html/sites/default
# sudo -E -u www-data drush updatedb
fi
echo "Site is ready at https://${VSITE_DOMAIN}"
#echo "Login using the following url"
# drush uli
