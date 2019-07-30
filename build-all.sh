# build all my images
# REPOSITORY_FROM='blackflysolutions/';
# docker build 6/apache/admin -t simuliidae-admin:6-apache-civicrm-5
docker build --build-arg REPOSITORY_FROM 7/apache/admin -t simuliidae-admin:7-apache-civicrm-5
docker build --build-arg REPOSITORY_FROM 8/apache/admin -t simuliidae-admin:8-apache-civicrm-5
