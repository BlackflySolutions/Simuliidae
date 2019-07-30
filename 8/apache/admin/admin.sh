#!/bin/bash
# Use my composer to build code if the base directory is empty
# Use the composer-drupal-optimizations to reduce memory use!
if [ -z "$(ls -A /var/www/drupal)" ]; then
  echo "Empty codebase, seting up latest stable Drupal code using composer."
  cd /var/www/drupal
  chown drupal .
  sudo -u drupal composer create-project drupal-composer/drupal-project:8.x-dev . --no-interaction  --no-install
  sudo -u drupal composer require --no-update zaporylie/composer-drupal-optimizations:^1.0
  sudo -u drupal composer install
  mkdir -p /var/www/drupal/config/sync
  chown www-data:www-data /var/www/drupal/config/sync
else
  echo "Detected existing Drupal codebase."
fi
cd /var/www/drupal
# Use drush to do a standard Drupal install, if settings file doesn't have my password
#if [ ! -f /var/www/drupal/web/sites/default/settings.php ]; then
if grep -q $MYSQL_PASSWORD /var/www/drupal/web/sites/default/settings.php; then
  # if I have a configured settings file, just run the updatedb and wait for further attention in bash
  echo "Drupal already installed"
  echo "Site is ready at https://${VSITE_DOMAIN}"
  # sudo -E -u www-data drush cr
  # sudo -E -u www-data drush updatedb
else
  /usr/local/bin/wait-for-it.sh vsql:3306
  # this will destroy any existing db, should I check first?
  VSITE_DEFAULT_MAIL="${VSITE}@civicrm.ca"
  sudo -E -u www-data drush site-install minimal \
   --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@vsql/$DRUPAL_DATABASE" \
   --yes \
   --site-name=${VSITE_NAME:-$VSITE} \
   --site-mail=${VSITE_ADMIN_MAIL:-$VSITE_DEFAULT_MAIL} \
   --account-name=${VSITE_ADMIN:-$VSITE} \
   --account-mail=${VSITE_ADMIN_MAIL:-$VSITE_DEFAULT_MAIL} \
   --db-su=root \
   --db-su-pw=$MYSQL_ROOT_PASSWORD 
  sudo -E -u www-data drush -y pm:enable toolbar
  sudo -E -u www-data drush -y theme:enable seven
  sudo -E -u www-data drush -y config-set system.theme admin seven
  sudo -E -u www-data drush -y config-set system.theme default ${VSITE_THEME:-seven}
  echo "Site Installation Completed"
  echo "Login using the following url"
  sudo -E -u www-data drush --uri="https://${VSITE_DOMAIN}" uli
fi
# install civicrm if not yet installed
if [ -d "/var/www/drupal/vendor/civicrm" ]; then
  echo "Detected existing CiviCRM codebase."
else
  # this should go away when we get to 5.13.x?
  # sudo -u drupal composer config repositories.zetacomponents-mail vcs https://github.com/civicrm/zetacomponents-mail.git
  sudo -u drupal composer require civicrm/civicrm-core:~5 civicrm/civicrm-drupal-8 roundearth/civicrm-composer-plugin
  # and enable/auto-install
  if [ ! -f /var/www/drupal/web/sites/default/civicrm_settings.php ]; then
    chmod ug+w /var/www/drupal/web/sites/default
    mysql -u root -p$MYSQL_PASSWORD -h vsql  -e "create database if not exists $CIVICRM_DATABASE; grant all on $CIVICRM_DATABASE.* to $MYSQL_USER@'%';"
    #UPDATE $DRUPAL_DATABASE.system SET status = 1 where name = 'civicrm'"
    sudo -E -u www-data drush -y pm:enable civicrm
    #civicrm-install --dbhost=vsql --dbname=$CIVICRM_DATABASE --dbpass=$MYSQL_PASSWORD --dbuser=$MYSQL_USER --site_url=$VSITE_DOMAIN --ssl=on --destination=sites/all/modules
    chmod ug-w /var/www/drupal/web/sites/default
    curl -LsS https://download.civicrm.org/cv/cv.phar -o /usr/local/bin/cv
    chmod +x /usr/local/bin/cv
    sudo -E -u www-data drush -y pm:enable civicrmtheme
    cv api Setting.create userFrameworkResourceURL="[cms.root]/libraries/civicrm/"
  fi
fi
echo "admin.sh initialization script complete."
#sudo -E -u www-data drush uli
