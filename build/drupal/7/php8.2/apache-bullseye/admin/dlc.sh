#!/bin/bash
# Install civicrm from tarballs in the 'standard' directory.
cd /var/www/html/sites/all/modules
curl -O -L https://download.civicrm.org/civicrm-$1-drupal.tar.gz
curl -O -L https://download.civicrm.org/civicrm-$1-l10n.tar.gz
tar -xzf civicrm-$1-drupal.tar.gz
tar -xzf civicrm-$1-l10n.tar.gz
rm civicrm-$1-drupal.tar.gz
rm civicrm-$1-l10n.tar.gz
