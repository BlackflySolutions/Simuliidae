#!/bin/bash
ARG1=$1
if [ -f /var/www/drupal/composer.json ] &&  [[ '--force' != $ARG1 ]]; then
  echo "Detected existing Drupal codebase. Use --force to overwrite."
else
  echo "Empty codebase, seting up Drupal $VSITE_DRUPAL_VER code using composer."
  mkdir -p /var/www/tmp
  cd /var/www/tmp
  chown drupal .
  sudo -u drupal composer create-project drupal/recommended-project:${VSITE_DRUPAL_VER} . --no-interaction  --no-install
  sudo -u drupal composer require --no-update drush/drush zaporylie/composer-drupal-optimizations:^1.1 --dev
  sudo -u drupal composer config --no-plugins allow-plugins.zaporylie/composer-drupal-optimizations true
  sudo -u drupal composer require --no-update drupal/core-recommended:${VSITE_DRUPAL_VER}
  sudo -u drupal composer require --no-update drupal/core-composer-scaffold:${VSITE_DRUPAL_VER}
  sudo -u drupal composer require --no-update drupal/core-project-message:${VSITE_DRUPAL_VER} 
  sudo -u drupal composer update
  cd /var/www/
  chown drupal drupal
  rsync -az tmp/ drupal
  chmod g+w /var/www/drupal/web/sites/default/
  mkdir -p /var/www/drupal/config/sync
  chown www-data:www-data /var/www/drupal/config/sync
fi
