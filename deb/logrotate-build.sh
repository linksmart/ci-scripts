#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "sh pre-post-build.sh"
  exit 1
}

echo "DEB Builder logrotate-file: https://github.com/linksmart/ci-scripts/blob/master/deb/logrotate-build.sh"

if [[ -z "$NAME" ]]; then
  usage  
fi

echo "/var/log/${NAME}.log {"  > logrotate-$NAME
echo "	compress"             >> logrotate-$NAME
echo "	copytruncate"         >> logrotate-$NAME
echo "	daily"                >> logrotate-$NAME
echo "	delaycompress"        >> logrotate-$NAME
echo "	missingok"            >> logrotate-$NAME
echo "	notifempty"           >> logrotate-$NAME
echo "	rotate 4"             >> logrotate-$NAME
echo "	size=10M"             >> logrotate-$NAME
echo "}"                      >> logrotate-$NAME