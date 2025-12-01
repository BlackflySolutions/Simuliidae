#!/bin/bash
# 1. project variant (directory)
# 2. compose file additions
export VSITE_SFTP_PORT=60666
export VSITE_SSH_PORT=60667
export VSITE_MYSQL_PORT=60668
export VSITE_PHPMYADMIN_PORT=60669
export VSITE_BACKUP_PORT=60670
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
#echo "-f ${VSITE_COMPOSE_PROJECT_VARIANT}/${BASE}.yml $CONFIGS config | sed 's/{VSITE/\${VSITE/g' | sed \"s/ \([^[:space:]]*\): ''$/ - \1/\" > ${VSITE_COMPOSE_PROJECT_VARIANT}/${GENNAME}.yml"
bin/docker-compose -f ${VSITE_COMPOSE_PROJECT_VARIANT}/${BASE}.yml $CONFIGS config \
  | sed 's/{VSITE/\${VSITE/g' | sed 's/{COMPOSE_PROJECT_NAME/\${COMPOSE_PROJECT_NAME/g' | sed "s/ \([^[:space:]]*\): ''$/ - \1/"  \
  | sed 's/60666/\${VSITE_SFTP_PORT}/' | sed 's/60667/\${VSITE_SSH_PORT}/' \
  | sed 's/60668/${VSITE_MYSQL_PORT}/' | sed 's/60669/${VSITE_PHPMYADMIN_PORT}/' | sed 's/60670/${VSITE_BACKUP_PORT}/' \
  | sed 's/cpus: 1.0/cpus: "1"/' | sed 's/cpus: 2.0/cpus: "2"/' \
  > ${VSITE_COMPOSE_PROJECT_VARIANT}/${GENNAME}.yml
