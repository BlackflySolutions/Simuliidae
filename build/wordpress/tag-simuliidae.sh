# tag all the wordpress images
REPOSITORY_TO='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  docker tag simuliidae-wordpress:vhttp-base-$VARIANT_TAG blackflysolutions/simuliidae-wordpress:vhttp-base-$VARIANT_TAG
  docker tag simuliidae-wordpress:admin-base-$VARIANT_TAG blackflysolutions/simuliidae-wordpress:admin-base-$VARIANT_TAG
  docker tag simuliidae-wordpress:vhttp-cms-$VARIANT_TAG blackflysolutions/simuliidae-wordpress:vhttp-cms-$VARIANT_TAG
  docker tag simuliidae-wordpress:admin-cms-$VARIANT_TAG blackflysolutions/simuliidae-wordpress:admin-cms-$VARIANT_TAG
  docker tag simuliidae-wordpress:vhttp-crm-$VARIANT_TAG blackflysolutions/simuliidae-wordpress:vhttp-crm-$VARIANT_TAG
  docker tag simuliidae-wordpress:admin-crm-$VARIANT_TAG blackflysolutions/simuliidae-wordpress:admin-crm-$VARIANT_TAG
done <variants.txt
