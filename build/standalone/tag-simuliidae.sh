# tag all the standalone images
REPOSITORY_TO='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  docker tag simuliidae-standalone:vhttp-base-$VARIANT_TAG blackflysolutions/simuliidae-standalone:vhttp-base-$VARIANT_TAG
  docker tag simuliidae-standalone:admin-base-$VARIANT_TAG blackflysolutions/simuliidae-standalone:admin-base-$VARIANT_TAG
  docker tag simuliidae-standalone:vhttp-crm-$VARIANT_TAG blackflysolutions/simuliidae-standalone:vhttp-crm-$VARIANT_TAG
  docker tag simuliidae-standalone:admin-crm-$VARIANT_TAG blackflysolutions/simuliidae-standalone:admin-crm-$VARIANT_TAG
done <variants.txt
