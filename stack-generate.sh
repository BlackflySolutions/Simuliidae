#!/bin/bash
# 1. project variant (directory)
# 2. compose file additions
export VSITE_COMPOSE_PROJECT_VARIANT=$1
BASE=${3:-base}.yml
if [[ -z $3 ]]; then
  GENNAME=$2.yml
else
  GENNAME=${3}-$2.yml
fi
docker-compose -f ${VSITE_COMPOSE_PROJECT_VARIANT}/$BASE -f ${2}.yml config | sed 's/{VSITE/\${VSITE/g' | sed "s/ \([^[:space:]]*\): ''$/ - \1/" > ${VSITE_COMPOSE_PROJECT_VARIANT}/$GENNAME
