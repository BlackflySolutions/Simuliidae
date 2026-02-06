# this project depends on the old docker-compose, pre-V2.
# this script gets the latest pre-V2 version
#        https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64
curl -SL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 -o docker-compose
chmod ugo+x docker-compose
