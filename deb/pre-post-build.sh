#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "CONFIGREPLACEASK=setting.conf params.conf"
  "sh pre-post-build.sh"
  exit 1
}

echo "DEB Builder pre-post-file: https://github.com/linksmart/ci-scripts/blob/master/deb/pre-post-build.sh"

if [[ -z "$NAME" ]]; then
  usage  
fi

if [[ -z "$CONFIGREPLACEASK" ]]; then
  usage  
fi

echo "#!/bin/bash"                                                                                                                                > postinst
echo ""                                                                                                                                          >> postinst

echo "if [ \"\$1\" = \"configure\" ]; then"                                                                                                      >> postinst
echo "  if [ -z \"\`id -u ${NAME}bot  2> /dev/null\`\" ]; then"                                                                                  >> postinst
echo "    adduser --system --group --home /nonexistent --gecos \"${NAME} User\" --no-create-home --disabled-password --quiet ${NAME}bot || true" >> postinst
echo "    usermod -G ${NAME}bot,adm ${NAME}bot"                                                                                                  >> postinst
echo "  fi"                                                                                                                                      >> postinst
echo ""                                                                                                                                          >> postinst
for conffile in $CONFIGREPLACEASK ; do
echo "  ucf --three-way /usr/share/${NAME}/etc/${conffile}.dpkg-new /etc/${NAME}/${conffile}"                                                    >> postinst
done
echo ""                                                                                                                                          >> postinst

echo "  chown -R ${NAME}bot:${NAME}bot /usr/local/bin/${NAME}"                                                                                   >> postinst
echo ""                                                                                                                                          >> postinst

echo "  chown -R ${NAME}bot:${NAME}bot /etc/${NAME}/"                                                                                            >> postinst
echo ""                                                                                                                                          >> postinst

if [ -f "logrotate-$NAME" ]; then
  echo "  touch /var/log/${NAME}.log"                                                                                                            >> postinst
  echo "  chown ${NAME}bot:${NAME}bot /var/log/${NAME}.log"                                                                                      >> postinst
  echo "  chmod 644 /var/log/${NAME}.log"                                                                                                        >> postinst
  echo ""                                                                                                                                        >> postinst
fi

if [[ -n "$DATADIR" ]]; then
  echo "  mkdir -p ${DATADIR}"                                                                                                                  >> postinst
  echo "  chown -R ${NAME}bot:${NAME}bot ${DATADIR}"                                                                                            >> postinst
  echo ""                                                                                                                                       >> postinst
fi

echo "fi"                                                                                                                                        >> postinst

echo "systemctl enable ${NAME}"                                       >> postinst
echo "systemctl daemon-reload"                                        >> postinst
echo ""                                                               >> postinst







echo "if [ -f /tmp/${NAME}_service_runner ]; then"                    >> postinst
echo "    service ${NAME} start"                                      >> postinst
echo "    rm /tmp/${NAME}_service_runner"                             >> postinst
echo "fi"                                                             >> postinst

echo "#!/bin/bash"                                                     > prerm
echo ""                                                               >> prerm
echo "if [[ \$(systemctl is-active ${NAME} || true) == \"active\" ]]" >> prerm
echo "then"                                                           >> prerm
echo "    touch /tmp/${NAME}_service_runner"                          >> prerm
echo "    service ${NAME} stop"                                       >> prerm
echo "fi"                                                             >> prerm
