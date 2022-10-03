#!/bin/bash
# 1. project variant (directory)
# 2. compose file additions
export THIS_NODE=`hostname`
echo "Using $THIS_NODE"
export VSITE_COMPOSE_PROJECT_VARIANT=$1
BASE=$2
shift 2
GENNAME=""
CONFIGS=""
# iterate
while test ${#} -gt 0
do
  ADD=$1
  if [[ -z $GENNAME ]]; then
    GENNAME=${BASE}-${ADD}
  else
    GENNAME=${GENNAME}-${ADD}
  fi
  if [[ -f "${VSITE_COMPOSE_PROJECT_VARIANT}/-${ADD}.yml" ]]; then
    CONFIGS="$CONFIGS -f ${VSITE_COMPOSE_PROJECT_VARIANT}/-${ADD}.yml"
  else
    CONFIGS="$CONFIGS -f $ADD.yml"
  fi
  shift
done
/opt/Simuliidae/compose/bin/docker-compose -f ${VSITE_COMPOSE_PROJECT_VARIANT}/${BASE}.yml $CONFIGS config | sed 's/{VSITE/\${VSITE/g' | sed "s/ \([^[:space:]]*\): ''$/ - \1/" > ${VSITE_COMPOSE_PROJECT_VARIANT}/${GENNAME}.yml
