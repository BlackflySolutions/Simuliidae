# get an env settings that is stored as a vsite swarm secret
MATCH="^$1="
export $(grep $MATCH /run/secrets/vsite | xargs)
