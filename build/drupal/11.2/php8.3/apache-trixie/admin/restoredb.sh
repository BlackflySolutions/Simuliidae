# restores backups 
MYSQLIMPORT_CMD=/usr/bin/mysqlimport
MYSQL_CMD=/usr/bin/mysql
#
DB_USER="root"
DB_PASSWORD="$MYSQL_ROOT_PASSWORD"
DB_NAMES="$MYSQL_DATABASE $CIVICRM_DATABASE"
DB_HOST="vsql"
#
RESTORE_DIR=/var/restore/vdb
#
# set $(date)
#
# restore a database from it's separate table files
# echo "$MYSQLIMPORT_CMD --local -u $DB_USER --delete $DB_NAME $RESTORE_DIR/*txt"
for DB_NAME in $DB_NAMES
do
  if [ $DB_NAME != "Database" -a $DB_NAME != "test" -a $DB_NAME != "mysql" ] 
  then 
    if [ -d $RESTORE_DIR/$DB_NAME ]
    then
      echo $RESTORE_DIR/$DB_NAME
      start=`date +%s`
      cd $RESTORE_DIR/$DB_NAME
      TABLESQLS=`ls *sql`
      for TABLESQL in $TABLESQLS
      do
        TABLE=${TABLESQL%.sql}
        $MYSQL_CMD -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e"SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';SET sql_log_bin=0; SET FOREIGN_KEY_CHECKS=0; USE $DB_NAME; DROP TABLE IF EXISTS $TABLE; SOURCE $RESTORE_DIR/$DB_NAME/$TABLE.sql;";
      done
      TABLETXTS=`ls *txt`
      for TABLETXT in $TABLETXTS 
      do
        TABLE=${TABLETXT%.txt}
        $MYSQL_CMD -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e"SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';SET sql_log_bin=0; SET FOREIGN_KEY_CHECKS=0; SET autocommit=0; SET unique_checks=0; USE $DB_NAME; 
LOAD DATA LOCAL INFILE \"$RESTORE_DIR/$DB_NAME/$TABLETXT\" INTO TABLE $TABLE; COMMIT;";
      done
      end=`date +%s`
      runtime=$((end-start))
      echo "runtime: $runtime"
    fi
  fi 
done
