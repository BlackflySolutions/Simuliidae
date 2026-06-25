# restore one of the (resticprofile) profiles of persistent volume contents
# using resticprofile
set -euo pipefail
IFS=$'\n\t'
if [ $# -lt 1 ]; then
  echo 1>&2 "$0: required argument profile, see profile.conf"
  exit 2
elif [ $# -gt 2 ]; then
  echo 1>&2 "$0: too many arguments!"
  exit 2
elif [ $# -lt 2 ]; then
  ARG2=""
else
  ARG2=$2
fi
# required argument part
PROFILE=$1
# get confirmation before doing it!
if  [[ '-y' != $ARG2 ]]; then
  resticprofile ${PROFILE}.restore latest --overwrite=if-changed --dry-run
  while true; do
      read -p "Restore this? " yn
      case $yn in
          [Yy]* ) echo 'Restoring now ... '; break;;
          [Nn]* ) echo 'Cancelled.'; exit;;
          * ) echo "Please answer y or n.";;
      esac
  done
fi
resticprofile ${PROFILE}.restore latest --overwrite=if-changed
