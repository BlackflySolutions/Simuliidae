#!/bin/bash
# Use my composer to build code if the base directory is empty
# Use the composer-drupal-optimizations to reduce memory use!
if [ -z "$(ls -A /var/www/drupal)" ]; then
  cd /var/www/drupal
  chown drupal .
  sudo -u drupal composer create-project drupal-composer/drupal-project:8.x-dev . --no-interaction  --no-install
  sudo -u drupal composer require --no-update zaporylie/composer-drupal-optimizations:^1.0
  sudo -u drupal composer install
  mkdir -p /var/www/drupal/config/sync
  chown www-data:www-data /var/www/drupal/config/sync
fi
cd /var/www/drupal
# Use drush to do a standard Drupal install, if settings file doesn't have my password
#if [ ! -f /var/www/drupal/web/sites/default/settings.php ]; then
if grep -q $MYSQL_PASSWORD /var/www/drupal/web/sites/default/settings.php; then
  # if I have a configured settings file, just run the updatedb and wait for further attention in bash
  sudo -E -u www-data drush cr
  sudo -E -u www-data drush updatedb
else
  /usr/local/bin/wait-for-it.sh vsql:3306
  # this will destroy any existing db, should I check first?
  sudo -E -u www-data drush site-install minimal \
   --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@vsql/$DRUPAL_DATABASE" \
   --yes \
   --site-name=$VSITE_NAME \
   --site-mail=$VSITE_ADMIN_MAIL \
   --account-name=$VSITE_ADMIN \
   --account-mail=$VSITE_ADMIN_MAIL \
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
  sudo -E -u www-data drush -y pm:enable toolbar
  sudo -E -u www-data drush -y theme:enable seven
  sudo -E -u www-data drush -y config-set system.theme admin seven
  sudo -E -u www-data drush -y config-set system.theme default ${VSITE_THEME:-seven}
  echo "Site Installation Completed"
  # TODO: report back to root that I have completed!
fi
echo "Site is ready at https://${VSITE_DOMAIN}"
echo "Login using the following url"
sudo -E -u www-data drush uli
