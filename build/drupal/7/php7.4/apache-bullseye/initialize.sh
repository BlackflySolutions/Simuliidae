#!/bin/bash
# Set the mail, varnish and redis host domains to the docker host ip for this container network.
VHOST_DOCKER_IP=`/sbin/ip route | awk '/default/ { print $3 }'`
echo "$VHOST_DOCKER_IP mail redis varnish" >> /etc/hosts
# Create a site symlink if requested
if [ -n "$VSITE_SITES" ]; then
  cd /var/www/html/sites
  VSITE_SITE_DIRS=${VSITE_SITES//,/ }
  for SITE_DIR in $VSITE_SITE_DIRS
  do
    ln -sfn default $SITE_DIR
  done
fi
# add in a handy symlink
#  mkdir /var/www/drupal
#  cd /var/www/drupal
#  ln -s /var/www/html git-7
if [ -f "/var/www/html/sites/default/conf/apache-custom.conf" ]; then
  cp /var/www/html/sites/default/conf/apache-custom.conf /etc/apache2/conf-available/vsite-custom.conf
  a2enconf vsite-custom
fi 
if [ -f "/var/www/html/sites/default/conf/robots.txt" ]; then
  cp /var/www/html/sites/default/conf/robots.txt /var/www/html/
fi 
#  cd /var/www/html
#  for f in sites/default/patch/*.patch ; do patch -p1 < "$f" ; done
#fi
