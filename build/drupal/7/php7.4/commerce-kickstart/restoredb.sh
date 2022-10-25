#!/bin/bash
# restores backups 
MYSQLIMPORT_CMD=/usr/bin/mysqlimport
MYSQL_CMD=/usr/bin/mysql
#
DB_USER="root"
DB_PASSWORD="$MYSQL_ROOT_PASSWORD"
DB_HOST="vsql"
#
RESTORE_DIR=/var/restore/vsql
DB_NAMES=`ls /var/restore/vsql/*sql`
#
# set $(date)
#
# restore a database from it's origin backup
# echo "$MYSQLIMPORT_CMD --local -u $DB_USER --delete $DB_NAME $RESTORE_DIR/*txt"
for DB_FILENAME in $DB_NAMES
do
  DB_FID=$(basename -- "$DB_FILENAME")
  DB_NAME="${DB_FID%.*}"
  echo $RESTORE_DIR/$DB_NAME
  start=`date +%s`
  $MYSQL_CMD -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e"DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME; GRANT ALL ON $DB_NAME.* to $MYSQL_USER@'%'; ";
  $MYSQL_CMD -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $RESTORE_DIR/${DB_NAME}.sql
  end=`date +%s`
  runtime=$((end-start))
  echo "runtime: $runtime"
done
