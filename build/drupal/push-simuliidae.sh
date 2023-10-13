# push all the simuliidae-drupal images
REPOSITORY_TO='blackflysolutions/';
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  VARIANT_TAG=$(echo $VARIANT_DIR | sed -e 's/\//-/g')
  docker push blackflysolutions/simuliidae-drupal:vhttp-base-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-drupal:admin-base-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-drupal:vhttp-cms-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-drupal:admin-cms-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-drupal:vhttp-crm-$VARIANT_TAG
  docker push blackflysolutions/simuliidae-drupal:admin-crm-$VARIANT_TAG
done <variants.txt
