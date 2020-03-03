# first argument is the slug value
# set the VSITE_SLUG_DIR environment variable if you want your env files in a different directory.
SLUG_DIR="${VSITE_SLUG_DIR:-vsite/}"
SLUG=$1
export $(grep -o '^[^#]*' $SLUG_DIR$SLUG.env | xargs)
docker-compose --project-directory $VSITE_COMPOSE_PROJECT -f ${VSITE_COMPOSE_PROJECT}/${VSITE_COMPOSE_PROJECT_VARIANT}.yml $2 $3 $4 $5
