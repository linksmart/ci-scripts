#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "DEBBUILDPATH=\$HOME/deb " \
  "sh pre-post-build.sh"
  exit 1
}

echo "DEB Builder pre-post-file: https://github.com/linksmart/ci-scripts/blob/master/deb/pre-post-build.sh"

if [[ -z "$NAME" ]]; then
  usage  
fi

if [[ -z "$DEBBUILDPATH" ]]; then
  usage
fi

mkdir -p $DEBBUILDPATH/DEBIAN

echo "#!/bin/bash"                           > $DEBBUILDPATH/DEBIAN/preinst
echo ""                                     >> $DEBBUILDPATH/DEBIAN/preinst
echo "useradd -M ${NAME}bot"                >> $DEBBUILDPATH/DEBIAN/preinst
echo "usermod -L ${NAME}bot"                >> $DEBBUILDPATH/DEBIAN/preinst
echo "groupadd ${NAME}bot"                  >> $DEBBUILDPATH/DEBIAN/preinst
echo "usermod -G ${NAME}bot,adm ${NAME}bot" >> $DEBBUILDPATH/DEBIAN/preinst

echo "#!/bin/bash"                                            > $DEBBUILDPATH/DEBIAN/postinst
echo ""                                                      >> $DEBBUILDPATH/DEBIAN/postinst
echo "systemctl enable ${NAME}"                              >> $DEBBUILDPATH/DEBIAN/postinst
echo "systemctl daemon-reload"                               >> $DEBBUILDPATH/DEBIAN/postinst
echo ""                                                      >> $DEBBUILDPATH/DEBIAN/postinst
echo "touch /var/log/${NAME}.log"                            >> $DEBBUILDPATH/DEBIAN/postinst
echo "chown ${NAME}bot:${NAME}bot /var/log/${NAME}.log"      >> $DEBBUILDPATH/DEBIAN/postinst
echo "chmod 644 /var/log/${NAME}.log"                        >> $DEBBUILDPATH/DEBIAN/postinst
echo ""                                                      >> $DEBBUILDPATH/DEBIAN/postinst
echo "chown -R ${NAME}bot:${NAME}bot /usr/local/bin/${NAME}" >> $DEBBUILDPATH/DEBIAN/postinst
echo ""                                                      >> $DEBBUILDPATH/DEBIAN/postinst
echo "if [ -f /tmp/${NAME}_service_runner ]; then"           >> $DEBBUILDPATH/DEBIAN/postinst
echo "    service ${NAME} start"                             >> $DEBBUILDPATH/DEBIAN/postinst
echo "    rm /tmp/${NAME}_service_runner"                    >> $DEBBUILDPATH/DEBIAN/postinst
echo "fi"                                                    >> $DEBBUILDPATH/DEBIAN/postinst

echo "#!/bin/bash"                                                  > $DEBBUILDPATH/DEBIAN/prerm
echo ""                                                            >> $DEBBUILDPATH/DEBIAN/prerm
echo "if [[ $(systemctl is-active ${NAME} || true) == "active" ]]" >> $DEBBUILDPATH/DEBIAN/prerm
echo "then"                                                        >> $DEBBUILDPATH/DEBIAN/prerm
echo "    touch /tmp/${NAME}_service_runner"                       >> $DEBBUILDPATH/DEBIAN/prerm
echo "    service ${NAME} stop"                                    >> $DEBBUILDPATH/DEBIAN/prerm
echo "fi"                                                          >> $DEBBUILDPATH/DEBIAN/prerm