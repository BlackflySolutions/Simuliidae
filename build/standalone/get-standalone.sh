#!/bin/bash
# get the Dockerfiles from the reference project
while read VARIANT_DIR; do
  echo "$VARIANT_DIR"
  REFERENCE_DOCKERFILE="../../reference/standalone/$VARIANT_DIR/Dockerfile"
  if [[ -f $REFERENCE_DOCKERFILE ]] ; then
    cp $REFERENCE_DOCKERFILE $VARIANT_DIR/
  else
    echo "Missing $REFERENCE_DOCKERFILE"
  fi
done <variants.txt
