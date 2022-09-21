# build all the drupal-civicrm images that I need.
# includes the 'base' images that do NOT include the drupal code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
# REPOSITORY_FROM='blackflysolutions/';
# docker build 6/apache/admin -t simuliidae-admin:6-apache
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  cp ../../reference/drupal/$VARIANT_DIR/Dockerfile $VARIANT_DIR/
  DOCKER_BUILDKIT=1 docker build --target=drupal-base -t drupal:base-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --target= -t drupal:drupal-$VARIANT_TAG $VARIANT_DIR
done <variants.txt
