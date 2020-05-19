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

echo "Package: $NAME\n" > $DEBBUILDPATH/DEBIAN/control
echo "Version: $VERSION\n" >> $DEBBUILDPATH/DEBIAN/control
echo "Section: base\n" >> $DEBBUILDPATH/DEBIAN/control
echo "Priority: optional\n" >> $DEBBUILDPATH/DEBIAN/control
echo "Architecture: $PLATFORM\n" >> $DEBBUILDPATH/DEBIAN/control
echo "Depends: $DEPENDENCIES\n" >> $DEBBUILDPATH/DEBIAN/control
echo "Maintainer: $MAINAINER\n" >> $DEBBUILDPATH/DEBIAN/control
echo "Description: $DESCRIPTION\n" >> $DEBBUILDPATH/DEBIAN/control
