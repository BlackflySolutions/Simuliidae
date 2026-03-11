#!/bin/bash
# simple script to launch mysql as root
echo "db: ${MYSQL_DATABASE}";
echo "civicrm db: ${CIVICRM_DATABASE}";
mysql -u root -p$MYSQL_PASSWORD -h vsql $MYSQL_DATABASE
