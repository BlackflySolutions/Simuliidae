#!/bin/bash
# simple script to launch mysql as root
echo "db: ${WORDPRESS_DB_NAME}";
mysql -u root -p$WORDPRESS_DB_PASSWORD -h vsql $WORDPRESS_DB_NAME
