# use drush to generate ad-hoc backups
TODAY=$(date +"%Y-%m-%d")
drush -y sql-dump --ordered-dump --gzip --result-file=/var/backup/vsql/drupal-${TODAY}.sql
# dump the civi db if it exists and is different from the drupal one.
if [ -n ${CIVICRM_DATABASE} ]; then
  if [ ${CIVICRM_DATABASE:-$DRUPAL_DATABASE} != ${DRUPAL_DATABASE} ]; then
    drush -y sql-dump --database=civicrm --ordered-dump --gzip --result-file=/var/backup/vsql/civicrm-${TODAY}.sql
  fi
fi
