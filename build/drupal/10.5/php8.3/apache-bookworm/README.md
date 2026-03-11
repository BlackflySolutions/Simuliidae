# This is used to build extended versions of the drupal-civicrm image, with production goodies that
# are not needed for testing or local/dev.
# Note: requires the IMAGE_FROM argument, which may be either the base or non-base version
# Goodies include:
# 1. the php pecl redis extension, to support the use of redis
# 2. imagemagick, because it's great
# 3. msmtprc: a way to send mail via the host's mail system
# 4. handling of varnish+hitch proxying by apache
# 5. the mcrypt pecl extension to support old civi upgrades
# 6. an ssh client and git, to support some automation
