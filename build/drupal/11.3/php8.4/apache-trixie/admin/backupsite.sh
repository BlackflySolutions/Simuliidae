# rsync sites dir to backup
rsync --exclude files/js --exclude files/css --exclude templates_c -avz /var/www/html/sites/default/ /var/backup/volume/${VSITE}_vsite
