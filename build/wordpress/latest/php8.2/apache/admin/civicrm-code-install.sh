#!/bin/bash
mkdir /var/www/html/wp-content/uploads
cd /var/www/html/wp-content/plugins 
curl -L https://download.civicrm.org/civicrm-${VSITE_CIVICRM_VER}-wordpress.zip > civicrm-wordpress.zip
unzip civicrm-wordpress.zip
rm civicrm-wordpress.zip
curl -L https://download.civicrm.org/civicrm-${VSITE_CIVICRM_VER}-l10n.tar.gz > civicrm-l10n.tar.gz 
tar -xzf civicrm-l10n.tar.gz 
rm civicrm-l10n.tar.gz
chown -R wordpress:www-data /var/www/html/wp-content/plugins/civicrm;
