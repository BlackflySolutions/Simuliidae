#!/bin/bash
# get the latest modified Dockerfiles and related files from the modified wordpress project in references
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  REFERENCE_DIR="../../reference/wordpress/$VARIANT_DIR/"
  REFERENCE_DOCKERFILE="$REFERENCE_DIR/Dockerfile"
  if [[ -f $REFERENCE_DOCKERFILE ]] ; then
    cp $REFERENCE_DIR/* $VARIANT_DIR/
  else
    echo "Missing $REFERENCE_DOCKERFILE"
  fi
done <variants.txt
