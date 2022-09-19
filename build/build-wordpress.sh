# build all the wordpress-civicrm images that I need.
# includes the 'base' images that do NOT include the wordpress code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
# REPOSITORY_FROM='blackflysolutions/';
DOCKER_BUILDKIT=1 docker build --target=wordpress-base -t wordpress-civicrm-base:latest-php7.4-apache ../reference/wordpress/latest/php7.4/apache/
DOCKER_BUILDKIT=1 docker build --target= -t wordpress-civicrm:latest-php7.4-apache ../reference/wordpress/latest/php7.4/apache/
DOCKER_BUILDKIT=1 docker build --target=wordpress-base -t wordpress-civicrm-base:latest-php8.0-apache ../reference/wordpress/latest/php8.0/apache/
DOCKER_BUILDKIT=1 docker build --target= -t wordpress-civicrm:latest-php8.0-apache ../reference/wordpress/latest/php8.0/apache/
DOCKER_BUILDKIT=1 docker build --target=wordpress-base -t wordpress-civicrm-base:latest-php8.1-apache ../reference/wordpress/latest/php8.1/apache/
DOCKER_BUILDKIT=1 docker build --target= -t wordpress-civicrm:latest-php8.1-apache ../reference/wordpress/latest/php8.1/apache/
