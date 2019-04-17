# 1. project variant (directory)
# 2. compose file additions
export VSITE_COMPOSE_PROJECT_VARIANT=$1
docker-compose -f ${VSITE_COMPOSE_PROJECT_VARIANT}/docker-compose.yml -f ${2}.yml config | sed 's/{VSITE/\${VSITE/g' | sed "s/ \([^[:space:]]*\): ''$/ - \1/" > ${VSITE_COMPOSE_PROJECT_VARIANT}/${2}.yml
