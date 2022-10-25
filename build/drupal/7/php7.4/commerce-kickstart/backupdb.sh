# use drush to generate ad-hoc backups
TODAY=$(date +"%Y-%m-%d")
drush -y sql-dump --ordered-dump --gzip --result-file=/var/backup/vsql/drupal-${TODAY}.sql
