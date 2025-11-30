# use restic to backup the filesystem
#
rsync --exclude files/js --exclude files/css --exclude templates_c -avz /var/www/html/sites/default/ /var/backup/volume/${VSITE}_vsite
