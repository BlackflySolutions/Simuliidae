# this project depends on the old docker-compose, pre-V2.
# this script gets the latest pre-V2 version
curl -SL https://github.com/docker/compose/releases/download/v1.29.2/docker-compose-linux-x86_64 -o docker-compose
chmod ugo+x docker-compose
