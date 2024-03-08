# tag all the standalone images
REPOSITORY_TO='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  docker tag standalone:base-$VARIANT_TAG blackflysolutions/standalone:base-$VARIANT_TAG
done <variants.txt
