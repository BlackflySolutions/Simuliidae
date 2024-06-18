#!/bin/bash
# build all the drupal-civicrm images that I need.
# includes the 'base' images that do NOT include the drupal code
# the civicrm in the image name refers to the additions in the required stack (see the modifications to Dockerfile.template)
# i.e. none of these include civicrm code
# REPOSITORY_FROM='blackflysolutions/';
# docker build 6/apache/admin -t simuliidae-admin:6-apache
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  REFERENCE_DOCKERFILE="../../reference/drupal/$VARIANT_DIR/Dockerfile"
  if [[ -f $REFERENCE_DOCKERFILE ]] ; then
    cp $REFERENCE_DOCKERFILE $VARIANT_DIR/
  else
    echo "Missing $REFERENCE_DOCKERFILE"
  fi
done <variants.txt
cp ../../reference/drupal/Dockerfile.template .
