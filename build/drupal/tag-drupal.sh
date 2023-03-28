# tag all the drupal images
REPOSITORY_TO='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  docker tag drupal:base-$VARIANT_TAG blackflysolutions/drupal:base-$VARIANT_TAG
done <variants.txt
