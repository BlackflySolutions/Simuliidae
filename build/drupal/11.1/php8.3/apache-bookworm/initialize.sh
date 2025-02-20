#!/bin/bash
# Set the mail, varnish and redis host domains to the docker host ip for this container network.
VHOST_DOCKER_IP=`/sbin/ip route | awk '/default/ { print $3 }'`
echo "$VHOST_DOCKER_IP mail redis varnish" >> /etc/hosts

# legacy support for migrated multisite installs, not recommended or tested recently
if [ -n "$VSITE_SITES" ]; then
  cd /var/www/drupal/web/sites
  VSITE_SITE_DIRS=${VSITE_SITES//,/ }
  for SITE_DIR in $VSITE_SITE_DIRS
  do
    ln -sfn default $SITE_DIR
  done
fi
# support for customizing your apache config, not recommended
if [ -f "/var/www/drupal/web/sites/default/conf/apache-custom.conf" ]; then
  cp /var/www/drupal/web/sites/default/conf/apache-custom.conf /etc/apache2/conf-available/vsite-custom.conf
  a2enconf vsite-custom
fi 
# support for a custom robots.txt
if [ -f "/var/www/drupal/web/sites/default/conf/robots.txt" ]; then
  cp /var/www/drupal/web/sites/default/conf/robots.txt /var/www/html/
fi 
