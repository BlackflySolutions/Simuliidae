FROM blackflysolutions/drupal:8-6-apache-civicrm-5
# an extended version of the webserver image, adding extra packages and scripts
RUN apt-get update \
  && apt-get install -y mariadb-client sudo vim git zip unzip netcat \
  && apt-get purge -y
COPY drush.phar /usr/local/bin/drush
# addiitional bits for d8-civicrm, composer + other build dependencies
# TODO: there may be better docker-specific ways to do this?
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g bower
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
# combine admin with previous line once it's settled down
COPY admin.sh /usr/local/bin/admin.sh
RUN chmod ugo+x /usr/local/bin/drush && chmod ugo+x /usr/local/bin/*.sh 
COPY admin.conf /etc/apache2/conf-available
RUN a2enconf admin
# CMD["apache2-foreground"]
# Run the same initialization script that vhttp does, and then the admin one.
CMD /usr/local/bin/admin.sh && apache2-foreground
