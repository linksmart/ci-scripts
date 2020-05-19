#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "DESCRIPTION=Testapp " \
  "EXEPATH=testapp" \
  "EXEARGUMENTS=-v" \
  "DEBBUILDPATH=\$HOME/deb " \
  "sh service-build.sh"
  exit 1
}

echo "DEB Builder pre-post-file: https://github.com/linksmart/ci-scripts/blob/master/deb/service-build.sh"

if [[ -z "$DESCRIPTION" ]]; then
  usage
fi

if [[ -z "$NAME" ]]; then
  usage  
fi

if [[ -z "$EXEPATH" ]]; then
  usage  
fi

if [[ -z "$DEBBUILDPATH" ]]; then
  usage
fi

if [[ -z "$EXEARGUMENTS" ]]; then
  usage
fi

INSTLOCAL="/usr/local/bin/$NAME"
BINARY="$INSTLOCAL/$EXEPATH"

mkdir -p "$DEBBUILDPATH/lib/systemd/system"

echo "[Unit]"                                                  > $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "Description=$DESCRIPTION"                               >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "After=network-online.target"                            >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo ""                                                       >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "[Service]"                                              >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "User=${NAME}bot"                                        >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "Group=${NAME}bot"                                       >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "WorkingDirectory=$INSTLOCAL"                            >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "PermissionsStartOnly=true"                              >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "ExecStartPre=setcap 'cap_net_bind_service=+ep' $BINARY" >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "ExecStart=$BINARY $EXEARGUMENTS"                        >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "KillMode=control-group"                                 >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "TimeoutStopSec=5"                                       >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "Restart=on-failure"                                     >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "StandardOutput=null"                                    >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "StandardError=syslog"                                   >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo ""                                                       >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "[Install]"                                              >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "WantedBy=multi-user.target"                             >> $DEBBUILDPATH/lib/systemd/system/$NAME.service
echo "Alias=$NAME.service"                                    >> $DEBBUILDPATH/lib/systemd/system/$NAME.service