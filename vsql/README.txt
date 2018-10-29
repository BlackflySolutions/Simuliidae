Overrides to mysql
[mysqldump]
max_allowed_packet = 1G
[client]
default-character-set = utf8
[mysqld]
log-warndings
collation-server                        = utf8_unicode_ci
init_connect                            = "SET collation_connection = utf8_general_ci"
character-set-server                    = utf8
character_set_filesystem                = utf8
skip-character-set-client-handshake
skip-name-resolve
back_log = 100
max_allowed_packet = 16M
innodb_file_per_table                   = 1
innodb_file_format                      = barracuda
innodb_flush_method                     = O_DIRECT
innodb_flush_log_at_trx_commit          = 2
long_query_time = 10
