#!/bin/bash

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
chmod 755 $DEBIAN -R

echo "Copy deb control files."

cp "service-$NAME" "$SYSTEMD/$NAME.service"
chmod 644 $SYSTEMD/"$NAME.service"

echo "Copy $NAME.service to $SYSTEMD."

cp -t $EXEC/ $COPYEXEC 
chmod 755 $EXEC/*
chmod 755 $EXEC

echo "Copy programm files to $EXEC."

cp -t $CONFIG/ $COPYCONFIG
chmod 644 $CONFIG/*
chmod 755 $CONFIG

echo "Copy example-conf to $CONFIG."

cp "logrotate-$NAME" "$LOGROTATE/$NAME.conf"
chmod 644 $LOGROTATE/*

echo "Copy $NAME.conf to $LOGROTATE."

dpkg-deb --build $ROOT

echo "Build deb packet."

TARGETFILE="${NAME}_${VERSION}_${PLATFORM}.deb"
mv $HOMEDIR/deb.deb "../Builds/$TARGETFILE"

echo "Move $TARGETFILE to Builds."

rm $HOMEDIR/deb -r

echo "Remove $HOMEDIR/deb."

echo "::set-output name=debuilderfile::$TARGETFILE"