#!/bin/bash
# TODO - don't run this before testing if there's already some code present!
cd /var/www/html
VERSION=${VSITE_WORDPRESS_VERSION:-latest}
curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-${VERSION}.tar.gz"; 
tar -xz --strip-components=1 -f wordpress.tar.gz; 
rm wordpress.tar.gz; 
# https://wordpress.org/support/article/htaccess/
	[ ! -e /var/www/html/.htaccess ]; \
	{ \
		echo '# BEGIN WordPress'; \
		echo ''; \
		echo 'RewriteEngine On'; \
		echo 'RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]'; \
		echo 'RewriteBase /'; \
		echo 'RewriteRule ^index\.php$ - [L]'; \
		echo 'RewriteCond %{REQUEST_FILENAME} !-f'; \
		echo 'RewriteCond %{REQUEST_FILENAME} !-d'; \
		echo 'RewriteRule . /index.php [L]'; \
		echo ''; \
		echo '# END WordPress'; \
	} > /var/www/html/.htaccess; 
chown -R www-data:www-data /var/www/html; 
chmod -R 1777 wp-content
cp /usr/local/bin/wp-config-docker.php /var/www/html/
# use "awk" to replace all instances of "put your unique phrase here" with a properly unique string (for AUTH_KEY and friends to have safe defaults if they aren't specified with environment variables)
awk '
	/put your unique phrase here/ {
		cmd = "head -c1m /dev/urandom | sha1sum | cut -d\\  -f1"
		cmd | getline str
		close(cmd)
		gsub("put your unique phrase here", str)
	}
	{ print }
' wp-config-docker.php > wp-config.php
# attempt to ensure that wp-config.php is owned by the run user
# could be on a filesystem that doesn't allow chown (like some NFS setups)
chown www-data:www-data wp-config.php 
