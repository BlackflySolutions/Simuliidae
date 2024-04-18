#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# Layer 1
# Provide an option to build a "base" target that doesn't include the code
FROM php:8.2-apache-bullseye AS standalone-base

# Layer 2
# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod expires rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
		libxml2-dev \
		libicu-dev \
		libc-client-dev \
		libkrb5-dev \
		libmcrypt-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
	; \
	\
	docker-php-ext-configure imap --with-imap-ssl --with-kerberos; \
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
		mysqli \
		dom \
		soap \
		sockets \
		intl \
		bcmath \
		gettext \
		imap \
	; \
	\
        pecl install -o apcu && docker-php-ext-enable apcu; \
        docker-php-ext-install exif; \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Layer 3 with build bits to allow for future upgrades in the container
FROM standalone-base as standalone-build-crm
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/
# We create a standalone user to own all the code, using 1978 as the uid
RUN useradd -u 1978 -g www-data -ms /bin/bash standalone
RUN mkdir -p /var/www/html
RUN chown standalone:www-data /var/www/html
WORKDIR /var/www/html
USER standalone:www-data
ENV CIVICRM_VERSION 5.69.5
RUN set -eux; \
  git clone https://github.com/civicrm/civicrm-standalone /var/www/standalone; \
  composer require --no-update -W "civicrm/civicrm-core:$CIVICRM_VERSION"; \
  composer require --no-update -W "civicrm/civicrm-packages:$CIVICRM_VERSION"; \
  composer update; 

# Add what is now an empty initialize script
COPY commands/initialize.sh /usr/local/bin/initialize.sh
COPY commands/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/*.sh 
# default entrypoint runs initialize and then default/inherited CMD to start apache
RUN chmod 775 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# inherited default CMD["apache2-foreground"], repeated here for good measure.
CMD ["apache2-foreground"]
# Now create with a different more minimal Layer 3 without build bits
# This image would only be upgraded via image update
FROM standalone-base as standalone-crm
COPY --from=standalone-build-crm /var/www/html  /var/www/html
COPY --from=standalone-build-crm /usr/local/bin  /usr/local/bin
# vim:set ft=dockerfile:
