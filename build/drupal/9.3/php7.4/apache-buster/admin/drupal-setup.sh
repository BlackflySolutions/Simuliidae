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
  # now some cleanups/customizations that I can't do with drush - redo the settings file!
  if [ -f /var/www/drupal/web/sites/default/default.settings.php ]; then
    cp /var/www/drupal/web/sites/default/default.settings.php /var/www/drupal/web/sites/default/settings.php
    HASH_SALT_SETTING='$settings["hash_salt"] = '
    HASH_SALT_SETTING+="'"
    HASH_SALT_SETTING+=`drush eval 'echo Drupal\Component\Utility\Crypt::randomBytesBase64(55)'`
    HASH_SALT_SETTING+="';"
    echo $HASH_SALT_SETTING >> /var/www/drupal/web/sites/default/settings.php
    echo 'include("sites/all/host/settings.local.php");' >> /var/www/drupal/web/sites/default/settings.php
    echo '# include("sites/all/host/z.redis.inc");' >> /var/www/drupal/web/sites/default/settings.php
    echo '$settings["config_sync_directory"] = "../config/sync";' >> /var/www/drupal/web/sites/default/settings.php
  fi
  sudo -E -u www-data drush -y pm:enable toolbar
  # sudo -E -u www-data drush -y pm:enable redis
  sudo -E -u www-data drush -y theme:enable claro
  sudo -E -u www-data drush -y config-set system.theme admin claro
  sudo -E -u www-data drush -y config-set system.theme default ${VSITE_THEME:-claro}
  echo "Site Installation Completed"
  echo "Login using the following url"
  sudo -E -u www-data drush --uri="https://${VSITE_DOMAIN}" uli
fi
