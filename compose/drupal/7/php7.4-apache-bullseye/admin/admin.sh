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
  echo "Installing minimal Drupal using $VSITE_SITE_NAME, $VSITE_ADMIN_MAIL, $VSITE_ADMIN_NAME"
  sudo -E -u www-data drush site-install minimal \
   --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@vsql/$DRUPAL_DATABASE" \
   --yes \
   --site-name="$VSITE_SITE_NAME" \
   --site-mail="$VSITE_ADMIN_MAIL" \
   --account-name="$VSITE_ADMIN_NAME" \
   --account-mail="$VSITE_ADMIN_MAIL" \
   --db-su=root \
   --db-su-pw=$MYSQL_ROOT_PASSWORD 
  sudo -E -u www-data drush -y vset theme_default ${VSITE_THEME:-bartik}
  sudo -E -u www-data drush -y vset admin_theme ${VSITE_THEME:-seven}
  # allow for initial setup using a site feature
  if [ ! -z $VSITE_FEATURE ]; then
    sudo -E -u www-data drush -y pm-enable $VSITE_FEATURE
    sudo -E -u www-data drush -y features-revert-all
  fi
  # allow for an additional non-uid-1 user to be created
  if [ ! -z $VSITE_USER_MAIL ]; then
    if [ -z $VSITE_USER_NAME ]; then
      VSITE_USER_NAME=$VSITE_USER_MAIL
    fi
    sudo -E -u www-data drush user-create $VSITE_USER_NAME --mail=$VSITE_USER_MAIL
    if [ ! -z $VSITE_USER_ROLE ]; then
      sudo -E -u www-data drush user-add-role "$VSITE_USER_ROLE" --mail=$VSITE_USER_MAIL 
    fi
  fi
  echo "Site Installation Completed"
  # TODO: report back to root that I have completed!
else
# if I have a settings files, just run the updatedb and wait for further attention in bash
  cd /var/www/html/sites/default
  sudo -E -u www-data drush cc drush
  sudo -E -u www-data drush updatedb
fi
# echo "Site is ready at https://${VSITE_DOMAIN}"
echo "Login using the following url"
sudo -E -u www-data drush --uri="${VSITE_DOMAIN}" uli 
