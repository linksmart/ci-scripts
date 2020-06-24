#!/bin/bash

echo "Build file for dpkg-deb: https://github.com/linksmart/ci-scripts/blob/master/deb/build-deb.sh"

echo "1. Catch all paths together for $NAME."

HOMEDIR=$HOME
ROOT="$HOMEDIR/deb"
OUTPUT="../bin/Release/netcoreapp3.0"

EXEC="$ROOT/usr/local/bin/$NAME"
CONFIG="$ROOT/etc/$NAME"
SHARE="$ROOT/usr/share/$NAME"
SYSTEMD="$ROOT/lib/systemd/system"
LOGROTATE="$ROOT/etc/logrotate.d"
DEBIAN="$ROOT/DEBIAN"

echo "2. Versionsumber and Arch: $VERSION, $PLATFORM."

echo "3. Create directorys."

mkdir -p $EXEC
mkdir -p $CONFIG
mkdir -p $SHARE/etc
mkdir -p $DEBIAN
mkdir -p $SYSTEMD
if [ -f "logrotate-$NAME" ]; then
  mkdir -p $LOGROTATE
fi

echo "4. Copy deb control files."

cp control $DEBIAN/control
cp postinst $DEBIAN
cp prerm $DEBIAN

echo "5. Copy $NAME.service to $SYSTEMD."

cp "service-$NAME" "$SYSTEMD/$NAME.service"

echo "6. Copy programm files to $EXEC."

cp -t $EXEC/ $COPYEXEC 

echo "7. Copy example-conf to $SHARE/etc."

cp -t $SHARE/etc/ $COPYCONFIG
touch $DEBIAN/conffiles
find $SHARE/etc -type f -printf "/usr/share/$NAME/etc/%P\n" > $DEBIAN/conffiles

echo "8. Copy $NAME.conf to $LOGROTATE."
if [ -f "logrotate-$NAME" ]; then
  cp "logrotate-$NAME" "$LOGROTATE/$NAME.conf"
else
  echo "No logrotate found"
fi

echo "9. Creating md5sum"

touch $DEBIAN/md5sums
pushd $ROOT >> /dev/null
find . -path ./DEBIAN -prune -o -type f -exec md5sum {} \; | sed "s-./--" >> $DEBIAN/md5sums
popd >> /dev/null

echo "10. Setting permissions"

chmod -R 755 $DEBIAN
chmod 644 $SYSTEMD/"$NAME.service"
chmod -R 755 $EXEC
chmod 644 $SHARE/etc/*
chmod 755 $CONFIG
if [ -f "logrotate-$NAME" ]; then
  chmod 644 $LOGROTATE/*
fi

echo "11. Build deb packet."

dpkg-deb --build $ROOT

echo "12. Move $TARGETFILE to Builds."

TARGETFILE="${NAME}_${VERSION}_${PLATFORM}.deb"
mv $HOMEDIR/deb.deb "../Builds/$TARGETFILE"
echo "::set-output name=debuilderfile::$TARGETFILE"

echo "13. Cleanup $HOMEDIR/deb."

rm $HOMEDIR/deb -r

echo "All steps completed."