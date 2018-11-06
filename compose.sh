# first argument is the slug value
# set the SLUG_DIR environment variable if you want your env files in a different directory.
SLUG_DIR="${SLUG_DIR:-}"
SLUG=$1
export $(grep -o '^[^#]*' $SLUG_DIR$SLUG.env | xargs) && cd $PROJECT_VARIANT && docker-compose $2 $3 $4 $5
