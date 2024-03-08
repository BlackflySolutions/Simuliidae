# build all the standalone-civicrm images that I need.
# includes the 'base' images that do NOT include the standalone code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
# REPOSITORY_FROM='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  DOCKER_BUILDKIT=1 docker build --target=standalone-base -t standalone:base-$VARIANT_TAG $VARIANT_DIR
  # DOCKER_BUILDKIT=1 docker build --target= -t standalone:standalone-$VARIANT_TAG $VARIANT_DIR
done <variants.txt
