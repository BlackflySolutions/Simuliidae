#!/bin/bash
# setup a .drush folder for my www-data user
if [ ! -d "/var/www/.drush" ]; then
  mkdir /var/www/.drush
  chown www-data:www-data /var/www/.drush
  sudo -E -u www-data drush -y @none dl --destination=/var/www/.drush registry_rebuild-7.x
fi
# Use my drush to do a standard Drupal install, if no settings file exists
if [ ! -f /var/www/html/sites/default/settings.php ]; then
  /usr/local/bin/wait-for-it.sh vsql:3306
  # this will destroy any existing db, should I check first?
  cd /var/www/html
  sudo -E -u www-data drush site-install minimal \
   --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@vsql/$DRUPAL_DATABASE" \
   --yes \
   --site-name=$VSITE_NAME \
   --site-mail=$VSITE_MAIL \
   --account-name=$VSITE_ADMIN \
   --account-mail=$VSITE_MAIL \
   --db-su=root \
   --db-su-pw=$MYSQL_ROOT_PASSWORD 
# install civicrm if available but not yet installed
  if [ -d /var/www/html/sites/all/modules/civicrm/drupal/drush ]; then
    if [ ! -f /var/www/html/sites/default/civicrm_settings.php ]; then
      cp -Rp /var/www/html/sites/all/modules/civicrm/drupal/drush  /var/www/.drush/civicrm-install
      chown -R www-data /var/www/.drush/civicrm-install
      sudo -E -u www-data drush -y cc drush
      chmod u+w /var/www/html/sites/default
      mysql -u root -p$MYSQL_PASSWORD -h vsql  -e "create database if not exists $CIVICRM_DATABASE; grant all on $CIVICRM_DATABASE.* to $MYSQL_USER@'%'; UPDATE $DRUPAL_DATABASE.system SET status = 1 where name = 'civicrm'"
      sudo -E -u www-data drush -y civicrm-install --dbhost=vsql --dbname=$CIVICRM_DATABASE --dbpass=$MYSQL_PASSWORD --dbuser=$MYSQL_USER --site_url=$VSITE_DOMAIN --ssl=on --destination=sites/all/modules
      chmod u-w /var/www/html/sites/default
      curl -LsS https://download.civicrm.org/cv/cv.phar -o /usr/local/bin/cv
      chmod +x /usr/local/bin/cv
      sudo -E -u www-data drush -y pm-enable civicrmtheme
    fi
  fi
  sudo -E -u www-data drush -y vset admin_theme ${VSITE_THEME:-seven}
  sudo -E -u www-data drush -y vset civicrm_theme_admin ${VSITE_THEME:-seven}
# allow for initial setup using a site feature, defaults to ctools
  sudo -E -u www-data drush -y pm-enable ${VSITE_FEATURE:-ctools}
  sudo -E -u www-data drush -y features-revert-all
  sudo -E -u www-data drush sql-query "UPDATE block SET status = 0 WHERE NOT(module = 'system' AND (delta = 'main' OR delta = 'help'))"
  echo "Site Installation Completed"
  # TODO: report back to root that I have completed!
else
# if I have a settings files, just run the updatedb and wait for further attention in bash
  cd /var/www/html/sites/default
  sudo -E -u www-data drush cc drush
  sudo -E -u www-data drush updatedb
fi
echo "Site is ready at https://${VSITE_DOMAIN}"
echo "Login using the following url"
sudo -E -u www-data drush uli
