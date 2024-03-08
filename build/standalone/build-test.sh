# build all the simuliidae-civicrm images that I need.
# includes the 'base' images that do NOT include the simuliidae code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
REPOSITORY_FROM='blackflysolutions/';
# docker build 6/apache/admin -t simuliidae-admin:6-apache
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
#  DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_FROM=simuliidae:base-$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp -t simuliidae-simuliidae:vhttp-base-$VARIANT_TAG $VARIANT_DIR
#  DOCKER_BUILDKIT=1 docker build --build-arg IMAGE_FROM=simuliidae:base-$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin -t simuliidae-simuliidae:admin-base-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=vhttp-base -t simuliidae-simuliidae:vhttp-base-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --build-arg REPOSITORY_FROM=$REPOSITORY_FROM --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-base -t simuliidae-simuliidae:admin-base-$VARIANT_TAG $VARIANT_DIR
#  DOCKER_BUILDKIT=1 docker build --build-arg VARIANT_TAG=$VARIANT_TAG -f $VARIANT_DIR/Simuliidae --target=admin-simuliidae -t simuliidae-simuliidae:admin-simuliidae-$VARIANT_TAG $VARIANT_DIR
done <variants-test.txt
