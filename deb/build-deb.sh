#!/bin/bash

exit 0

HOMEDIR=$HOME
ROOT="$HOMEDIR/deb"
OUTPUT="../bin/Release/netcoreapp3.0"

EXEC="$ROOT/usr/local/bin/$NAME"
CONFIG="$ROOT/etc/$NAME"
SYSTEMD="$ROOT/lib/systemd/system"
LOGROTATE="$ROOT/etc/logrotate.d"
DEBIAN="$ROOT/DEBIAN"

echo "Catch all paths together for $NAME."

echo "Versionsumber and Arch: $VERSION, $PLATFORM."

mkdir -p $EXEC
mkdir -p $CONFIG
mkdir -p $DEBIAN
mkdir -p $SYSTEMD
mkdir -p $LOGROTATE

echo "Created directorys."

cp control $DEBIAN/control
cp preinst $DEBIAN
cp postinst $DEBIAN
cp prerm $DEBIAN
sed -i s/Version:\ x\.x-x/"Version: $VERSION"/ $DEBIAN/control
sed -i s/Architecture:\ any/"Architecture: $PLATFORM"/ $DEBIAN/control
chmod 755 $DEBIAN -R

echo "Copy deb control files."

cp "service-$NAME" "$SYSTEMD/$NAME.service"
chmod 644 $SYSTEMD/"$NAME.service"

echo "Copy $NAME.service to $SYSTEMD."

cp -t $EXEC/ $COPYEXEC 
chmod 644 $EXEC/*
chmod 755 $EXEC

echo "Copy programm files to $EXEC."

cp -t $EXEC/ $COPYCONFIG
chmod 644 $CONFIG/*
chmod 755 $CONFIG

echo "Copy example-conf to $CONFIG."

cp "logrotate-$NAME" "$LOGROTATE/$NAME.conf"
chmod 644 $LOGROTATE/*

echo "Copy $NAME.conf to $LOGROTATE."

dpkg-deb --build $ROOT

echo "Build deb packet."

TARGETFILE="$NAME""_$VERSION.deb"
mv $HOMEDIR/deb.deb "Builds/$PLATFORM-$TARGETFILE"

echo "Move $PLATFORM-$TARGETFILE to Builds."

rm $HOMEDIR/deb -r

echo "Remove $HOMEDIR/deb."

echo "::set-output name=debuilderfile::$TARGETFILE"