#!/bin/bash
# Use wp-cli to do a standard Wordpress install, if no settings file exists
/usr/local/bin/wait-for-it.sh vsql:3306
# this will destroy any existing db, should I check first?
cd /var/www/html
mkdir -p /var/www/html/wp-content/uploads
chown www-data:www-data /var/www/html/wp-content/uploads
echo "Installing WordPress using $VSITE_SITE_NAME, $VSITE_ADMIN_MAIL, $VSITE_ADMIN_NAME"
sudo -E -u www-data wp core install \
    --url="$VSITE_DOMAIN" \
    --title="$VSITE_SITE_NAME" \
    --admin_user="$VSITE_ADMIN_NAME" \
    --admin_email="$VSITE_ADMIN_MAIL"
wp plugin install one-time-login --activate --allow-root
echo "Site Installation Completed"
