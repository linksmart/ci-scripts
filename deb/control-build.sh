#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "PLATFORM=amd64 " \
  "DEPENDENCIES=\"libc-bin (>= 2.19)\" " \
  "MAINAINER=\"Test <email@example>\" " \
  "DESCRIPTION=Testapp " \
  "DEBBUILDPATH=\$HOME/deb " \
  "VERSION=1.0-0 " \
  "sh control-build.sh"
  exit 1
}

echo "DEB Builder control-file: https://github.com/linksmart/ci-scripts/blob/master/deb/control-build.sh"

if [[ -z "$NAME" ]]; then
  usage  
fi

if [[ -z "$PLATFORM" ]]; then
  usage
fi

if [[ -z "$DEPENDENCIES" ]]; then
  usage
fi

if [[ -z "$MAINAINER" ]]; then
  usage
fi

if [[ -z "$DESCRIPTION" ]]; then
  usage
fi

if [[ -z "$DEBBUILDPATH" ]]; then
  usage
fi

if [[ -z "$VERSION" ]]; then
  usage
fi

mkdir -p $DEBBUILDPATH/DEBIAN

echo "Package: $NAME" > $DEBBUILDPATH/DEBIAN/control
echo "Version: $VERSION" >> $DEBBUILDPATH/DEBIAN/control
echo "Section: base" >> $DEBBUILDPATH/DEBIAN/control
echo "Priority: optional" >> $DEBBUILDPATH/DEBIAN/control
echo "Architecture: $PLATFORM" >> $DEBBUILDPATH/DEBIAN/control
echo "Depends: $DEPENDENCIES" >> $DEBBUILDPATH/DEBIAN/control
echo "Maintainer: $MAINAINER" >> $DEBBUILDPATH/DEBIAN/control
echo "Description: $DESCRIPTION" >> $DEBBUILDPATH/DEBIAN/control
