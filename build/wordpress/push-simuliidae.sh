# push all the simuliidae-wordpress images
REPOSITORY_TO='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  docker push blackflysolutions/simuliidae-wordpress:vhttp-base-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-wordpress:admin-base-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-wordpress:vhttp-cms-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-wordpress:admin-cms-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-wordpress:vhttp-crm-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-wordpress:admin-crm-$VARIANT_TAG
done <variants.txt
