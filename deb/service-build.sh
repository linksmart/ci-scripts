#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "DESCRIPTION=Testapp " \
  "EXEPATH=testapp" \
  "EXEARGUMENTS=-v" \
  "sh service-build.sh"
  exit 1
}

echo "DEB Builder service-file: https://github.com/linksmart/ci-scripts/blob/master/deb/service-build.sh"

if [[ -z "$DESCRIPTION" ]]; then
  usage
fi

if [[ -z "$NAME" ]]; then
  usage  
fi

if [[ -z "$EXEPATH" ]]; then
  usage  
fi

if [[ -z "$EXEARGUMENTS" ]]; then
  usage
fi

INSTLOCAL="/usr/local/bin/$NAME"
BINARY="$INSTLOCAL/$EXEPATH"

echo "[Unit]"                                                  > service-$NAME
echo "Description=$DESCRIPTION"                               >> service-$NAME
echo "After=network-online.target"                            >> service-$NAME
echo "Wants=network-online.target"                            >> service-$NAME
echo ""                                                       >> service-$NAME
echo "[Service]"                                              >> service-$NAME
echo "User=${NAME}bot"                                        >> service-$NAME
echo "Group=${NAME}bot"                                       >> service-$NAME
echo "WorkingDirectory=$INSTLOCAL"                            >> service-$NAME
if [[ -n "$ENVIROMENTVARS" ]]; then
  for enviromentvar in $ENVIROMENTVARS
  do
    echo "Environment=\"${enviromentvar}\""                   >> service-$NAME
  done
fi
echo "PermissionsStartOnly=true"                              >> service-$NAME
echo "ExecStartPre=setcap 'cap_net_bind_service=+ep' $BINARY" >> service-$NAME
echo "ExecStart=$BINARY $EXEARGUMENTS"                        >> service-$NAME
echo "KillMode=control-group"                                 >> service-$NAME
echo "TimeoutStopSec=5"                                       >> service-$NAME
echo "Restart=on-failure"                                     >> service-$NAME
if [[ -n "$LOGOUTPUT" ]]; then
  echo "StandardOutput=$LOGOUTPUT"                            >> service-$NAME
else
  echo "StandardOutput=null"                                  >> service-$NAME
fi
echo "StandardError=syslog"                                   >> service-$NAME
echo ""                                                       >> service-$NAME
echo "[Install]"                                              >> service-$NAME
echo "WantedBy=multi-user.target"                             >> service-$NAME
echo "Alias=$NAME.service"                                    >> service-$NAME
