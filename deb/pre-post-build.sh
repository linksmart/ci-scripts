#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "sh pre-post-build.sh"
  exit 1
}

echo "DEB Builder pre-post-file: https://github.com/linksmart/ci-scripts/blob/master/deb/pre-post-build.sh"

if [[ -z "$NAME" ]]; then
  usage  
fi

echo "#!/bin/bash"                                                     > preinst
echo ""                                                               >> preinst
echo "useradd -M ${NAME}bot"                                          >> preinst
echo "usermod -L ${NAME}bot"                                          >> preinst
echo "groupadd ${NAME}bot"                                            >> preinst
echo "usermod -G ${NAME}bot,adm ${NAME}bot"                           >> preinst

echo "#!/bin/bash"                                                     > postinst
echo ""                                                               >> postinst
echo "systemctl enable ${NAME}"                                       >> postinst
echo "systemctl daemon-reload"                                        >> postinst
echo ""                                                               >> postinst
echo "touch /var/log/${NAME}.log"                                     >> postinst
echo "chown ${NAME}bot:${NAME}bot /var/log/${NAME}.log"               >> postinst
echo "chmod 644 /var/log/${NAME}.log"                                 >> postinst
echo ""                                                               >> postinst
echo "chown -R ${NAME}bot:${NAME}bot /usr/local/bin/${NAME}"          >> postinst
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