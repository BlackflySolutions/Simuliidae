# build all the drupal-civicrm images that I need.
# includes the 'base' images that do NOT include the drupal code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
# REPOSITORY_FROM='blackflysolutions/';
# docker build 6/apache/admin -t simuliidae-admin:6-apache
DOCKER_BUILDKIT=1 docker build --target=drupal-base -t drupal-civicrm-base:7-php7.4-apache-buster ../reference/drupal/7/php7.4/apache-buster/
DOCKER_BUILDKIT=1 docker build --target= -t drupal-civicrm:7-php7.4-apache-buster ../reference/drupal/7/php7.4/apache-buster/
DOCKER_BUILDKIT=1 docker build --target=drupal-base -t drupal-civicrm-base:9.3-php7.4-apache-buster ../reference/drupal/9.3/php7.4/apache-buster/
DOCKER_BUILDKIT=1 docker build --target= -t drupal-civicrm:9.3-php7.4-apache-buster ../reference/drupal/9.3/php7.4/apache-buster/
DOCKER_BUILDKIT=1 docker build --target=drupal-base -t drupal-civicrm-base:9.4-php8.0-apache-buster ../reference/drupal/9.4/php8.0/apache-buster/
DOCKER_BUILDKIT=1 docker build --target= -t drupal-civicrm:9.4-php8.0-apache-buster ../reference/drupal/9.4/php8.0/apache-buster/
