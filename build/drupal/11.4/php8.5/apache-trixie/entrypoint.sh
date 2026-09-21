#!/bin/bash
/usr/local/bin/initialize.sh
# Hand off to the CMD
if test -z "$@"
then
  apache2-foreground
else
  exec "$@"
fi
