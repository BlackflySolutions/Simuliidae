#!/bin/bash
# Set the mail and varnish host domains to the docker host ip for this container network.
VHOST_DOCKER_IP=`/sbin/ip route | awk '/default/ { print $3 }'`
echo "$VHOST_DOCKER_IP mail varnish" >> /etc/hosts
