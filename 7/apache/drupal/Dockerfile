FROM drupal:7-apache
# extend the drupal:7-apache container for CiviCRM 5
RUN set -eux; \
        savedAptMark="$(apt-mark showmanual)";\
        apt-get update; \
        apt-get install -y --no-install-recommends \
		libxml2-dev \
		libmagickwand-dev \
		libmcrypt-dev \
		libicu-dev \
		libc-client-dev \
		libkrb5-dev \
                imagemagick \
        ; \
        docker-php-ext-configure imap --with-imap-ssl --with-kerberos; \
        docker-php-ext-install -j "$(nproc)" \
		mysqli \
		dom \
		soap \
		sockets \
		intl \
		bcmath \
		gettext \
		imap \
        ;\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
  pecl install -o imagick-3.4.3 && docker-php-ext-enable imagick; \
  pecl install -o mcrypt-1.0.2 && docker-php-ext-enable mcrypt; \
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

# download CiviCRM, specified version defaulting to STABLE
ARG CIVICRM_VERSION=STABLE
ARG CIVICRM_BRANCH=latest
RUN set -eux; \
        cd sites/all/modules/; \
        curl -fSL "https://download.civicrm.org/${CIVICRM_BRANCH}/civicrm-${CIVICRM_VERSION}-drupal.tar.gz" -o civicrm-drupal.tar.gz; \
	tar -xzf civicrm-drupal.tar.gz; \
	rm civicrm-drupal.tar.gz; \
	chown -R www-data:www-data civicrm
