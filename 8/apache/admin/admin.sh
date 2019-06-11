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
  # TODO: report back to root that I have completed!
fi
echo "Site is ready at https://${VSITE_DOMAIN}"
echo "Login using the following url"
sudo -E -u www-data drush uli
