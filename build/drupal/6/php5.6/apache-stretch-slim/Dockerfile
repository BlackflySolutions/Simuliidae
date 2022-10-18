# from https://www.drupal.org/docs/8/system-requirements/drupal-8-php-requirements
FROM php:5.6-apache as drupal-base
RUN apt-get update && apt-get upgrade -y
# install the PHP extensions we need
RUN set -ex; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libxml2-dev \
		libmagickwand-dev \
		libmcrypt-dev \
		libicu-dev \
		libc-client-dev \
		libkrb5-dev \
                imagemagick \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
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
		mcrypt \
		intl \
		bcmath \
		gettext \
		imap \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
  pecl install -o imagick-3.4.3 && docker-php-ext-enable imagick; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
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
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html
FROM drupal-base

ADD https://api.github.com/repos/d6lts/drupal/git/refs/heads/6.x version.json
RUN curl -L "https://github.com/d6lts/drupal/tarball/6.x" > drupal.tar.gz \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz 

# vim:set ft=dockerfile:
