# build all the simuliidae images
# these are all built from the drupal-civicrm images and add drupal/civicrm production and deployment utility layers
# for the non-base versions (built from non-base drupal images), they also include civicrm code.
# REPOSITORY_FROM='blackflysolutions/';
IMAGE_FROM=drupal-civicrm-base:7-php7.4-apache-buster DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_FROM --target=vhttp -t simuliidae-base-vhttp:7-php7.4-apache-buster 7/php7.4/apache-buster/
IMAGE_FROM=drupal-civicrm-base:7-php7.4-apache-buster DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_FROM --target=admin -t simuliidae-base-admin:7-php7.4-apache-buster 7/php7.4/apache-buster/
IMAGE_FROM=drupal-civicrm-base:9.3-php7.4-apache-buster DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_FROM --target=vhttp -t simuliidae-base-vhttp:9.3-php7.4-apache-buster 9.3/php7.4/apache-buster/
IMAGE_FROM=drupal-civicrm-base:9.3-php7.4-apache-buster DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_FROM --target=admin -t simuliidae-base-admin:9.3-php7.4-apache-buster 9.3/php7.4/apache-buster/
