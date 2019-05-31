# an extended version of the webserver image for administration
ARG REPOSITORY_FROM=blackflysolutions/
FROM ${REPOSITORY_FROM}drupal:8-apache-civicrm-5
# run apache as minimally as possible with a custom conf file
COPY admin.conf /etc/apache2/conf-available
RUN a2enconf admin
# add extra packages and scripts
RUN apt-get update \
  && apt-get install -y mariadb-client sudo vim git zip unzip netcat \
  && apt-get purge -y
# drush launcher: drush is/was installed by composer
RUN curl -L -o /usr/local/bin/drush https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar
RUN chmod ugo+x /usr/local/bin/drush
# wait-for-it script because I need a working sql container before installing
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
# add composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin
# add additional dependencies for installing civicrm with D8 + composer
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g bower
# create a user to own the drupal code and run the build process
# note that this user does not exist in the vhttp/run image!
RUN useradd -u 1978 -g www-data -ms /bin/bash drupal
RUN chown drupal:www-data /var/www/drupal
COPY admindb.sh /usr/local/bin/admindb.sh
# the admin.sh script will initialize the volumes if it's an empty site
COPY admin.sh /usr/local/bin/admin.sh
RUN chmod ugo+x /usr/local/bin/*.sh 
#CMD["apache2-foreground"]
# Run the same initialization script that vhttp does, and then the admin one.
# CMD apache2-foreground
CMD /usr/local/bin/admin.sh && apache2-foreground
