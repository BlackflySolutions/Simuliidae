sudo -u drupal curl -o /tmp/civicrm-l10n.tar.gz -L -O https://download.civicrm.org/civicrm-${VSITE_CIVICRM_VER}-l10n.tar.gz 
sudo -u drupal tar -xzf /tmp/civicrm-l10n.tar.gz --strip-components=1 -C /var/www/drupal/vendor/civicrm/civicrm-core
rm /tmp/civicrm-l10n.tar.gz
