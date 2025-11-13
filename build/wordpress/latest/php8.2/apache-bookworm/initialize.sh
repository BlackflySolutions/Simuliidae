#!/bin/bash
# Set the mail and varnish host domains to the docker host ip for this container network.
VHOST_DOCKER_IP=`/sbin/ip route | awk '/default/ { print $3 }'`
echo "$VHOST_DOCKER_IP mail varnish" >> /etc/hosts
# support for customizing your apache config, not recommended
if [ -f "/var/www/html/conf/apache-custom.conf" ]; then
  cp /var/www/html/conf/apache-custom.conf /etc/apache2/conf-available/vsite-custom.conf
  a2enconf vsite-custom
fi
