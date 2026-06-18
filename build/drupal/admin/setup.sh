#!/bin/bash
# Use my drush to do a standard Drupal install, if no settings file exists
if [ ! -f /var/www/html/sites/default/settings.php ]; then
  /usr/local/bin/wait-for-it.sh vsql:3306
  cd /var/www/html/sites/default
#  echo "user: ${MYSQL_USER}";
#  echo "db: ${DRUPAL_DATABASE}";
#  echo "civicrm db: ${CIVICRM_DATABASE}";
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
  sudo -E -u www-data drush -y pm-enable ${VSITE_THEME:-shoreditch}
  sudo -E -u www-data drush -y pm-enable ${VSITE_ADMIN_THEME:-seven}
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
      sudo -E -u www-data drush -y civicrm-ext-install ca.civicrm.logviewer 
      #if [[ $VSITE_CIVICRM_VER == "4.7" ]]; then
        sudo -E -u www-data drush -y civicrm-ext-install org.civicrm.shoreditch
        curl -LsS https://download.civicrm.org/cv/cv.phar -o /usr/local/bin/cv
        chmod +x /usr/local/bin/cv
        cv api setting.create customCSSURL=/vendor/org.civicrm.shoreditch/css/custom-civicrm.css
      # fi
      sudo -E -u www-data drush -y pm-enable civicrmtheme
    fi
  fi
  sudo -E -u www-data drush -y vset theme_default ${VSITE_THEME:-shoreditch}
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
# sudo -E -u www-data drush updatedb
fi
echo "Site is ready at https://${VSITE_DOMAIN}"
#echo "Login using the following url"
# drush uli
