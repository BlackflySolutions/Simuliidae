#!/bin/bash
# Set the mail, varnish and redis host domains to the docker host ip for this container network.
VHOST_DOCKER_IP=`/sbin/ip route | awk '/default/ { print $3 }'`
echo "$VHOST_DOCKER_IP mail redis varnish" >> /etc/hosts
