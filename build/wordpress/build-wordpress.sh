# build all the wordpress-civicrm images that I need.
# includes the 'base' images that do NOT include the wordpress code
# REPOSITORY_FROM='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  cp ../../reference/wordpress/$VARIANT_DIR/* $VARIANT_DIR/
  DOCKER_BUILDKIT=1 docker build --target=wordpress-base -t wordpress:base-$VARIANT_TAG $VARIANT_DIR
  DOCKER_BUILDKIT=1 docker build --target= -t wordpress:wordpress-$VARIANT_TAG $VARIANT_DIR
done <variants.txt
