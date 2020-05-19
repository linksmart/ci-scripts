#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "DEBBUILDPATH=\$HOME/deb " \
  "sh pre-post-build.sh"
  exit 1
}

echo "DEB Builder logrotate-file: https://github.com/linksmart/ci-scripts/blob/master/deb/logrotate-build.sh"

if [[ -z "$NAME" ]]; then
  usage  
fi

if [[ -z "$DEBBUILDPATH" ]]; then
  usage
fi

mkdir -p $DEBBUILDPATH/etc/logrotate.d

echo "/var/log/${NAME}.log {"  > $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	compress"             >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	copytruncate"         >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	daily"                >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	delaycompress"        >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	missingok"            >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	notifempty"           >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	rotate 4"             >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "	size=10M"             >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf
echo "}"                      >> $DEBBUILDPATH/etc/logrotate.d/$NAME.conf