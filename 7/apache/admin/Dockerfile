FROM blackflysolutions/drupal:7-apache-civicrm-5
# an extended version of the webserver image, adding extra packages and scripts
RUN apt-get update \
  && apt-get install -y mariadb-client sudo vim git zip unzip netcat \
  && apt-get purge -y
COPY drush.phar /usr/local/bin/drush
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
# combine admin with previous line once it's settled down
COPY admin.sh /usr/local/bin/admin.sh
RUN chmod ugo+x /usr/local/bin/drush && chmod ugo+x /usr/local/bin/*.sh 
COPY admin.conf /etc/apache2/conf-available
RUN a2enconf admin
# CMD["apache2-foreground"]
# Run the same initialization script that vhttp does, and then the admin one.
CMD /usr/local/bin/admin.sh && apache2-foreground
