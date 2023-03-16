# build all the drupal-civicrm images that I need.
# includes the 'base' images that do NOT include the drupal code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
#REPOSITORY_FROM='blackflysolutions/';
REPOSITORY_FROM='';
# docker build 6/apache/admin -t simuliidae-admin:6-apache
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp-base -t simuliidae-drupal:vhttp-base-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-base -t simuliidae-drupal:admin-base-$VARIANT_TAG $VARIANT_DIR
# DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-build-crm -t simuliidae-drupal:admin-build-crm-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp-cms -t simuliidae-drupal:vhttp-cms-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-cms -t simuliidae-drupal:admin-cms-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp-crm -t simuliidae-drupal:vhttp-crm-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-crm -t simuliidae-drupal:admin-crm-$VARIANT_TAG $VARIANT_DIR
done <variants.txt
