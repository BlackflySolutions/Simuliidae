#!/bin/bash
# Use my drush to initialize a drupal site.
echo "Initializing a drupal installation"
cd /var/www/drupal
# Use drush to do a standard Drupal install, if settings file doesn't have my password
#if [ ! -f /var/www/drupal/web/sites/default/settings.php ]; then
if grep -q $MYSQL_PASSWORD /var/www/drupal/web/sites/default/settings.php; then
  # if I have a configured settings file, quit with a message.
  echo "Drupal already installed"
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
