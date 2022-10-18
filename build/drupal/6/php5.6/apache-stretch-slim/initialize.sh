#!/bin/bash
# Set the mail, varnish and redis host domains to the docker host ip for this container network.
VHOST_DOCKER_IP=`/sbin/ip route | awk '/default/ { print $3 }'`
echo "$VHOST_DOCKER_IP mail varnish" >> /etc/hosts
# Create a site symlink if requested
if [ -n "$VSITE_SITES" ]; then
  cd /var/www/html/sites
  ln -s default $VSITE_SITES 
fi
if [ -f "/var/www/html/sites/default/conf/apache-custom.conf" ]; then
  cp /var/www/html/sites/default/conf/apache-custom.conf /etc/apache2/conf-available/vsite-custom.conf
  a2enconf vsite-custom
fi 
