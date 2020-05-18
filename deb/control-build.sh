#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: NAME=app PLATFORM=amd64 DEPENDENCIES=\"libc-bin (>= 2.19)\" MAINAINER=\"Test <email@example>\" DESCRIPTION=Testapp sh control-build.sh"
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

echo "Package: $NAME\n" > $HOME/deb/DEBIAN/control
echo "Version: x.x-x\n" >> $HOME/deb/DEBIAN/control
echo "Section: base\n" >> $HOME/deb/DEBIAN/control
echo "Priority: optional\n" >> $HOME/deb/DEBIAN/control
echo "Architecture: $PLATFORM\n" >> $HOME/deb/DEBIAN/control
echo "Depends: $DEPENDENCIES\n" >> $HOME/deb/DEBIAN/control
echo "Maintainer: $MAINAINER\n" >> $HOME/deb/DEBIAN/control
echo "Description: $DESCRIPTION\n" >> $HOME/deb/DEBIAN/control
