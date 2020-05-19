#!/bin/bash

# EXAMPLES
usage() {
  echo "usage: " \
  "NAME=app " \
  "PLATFORM=amd64 " \
  "DEPENDENCIES=\"libc-bin (>= 2.19)\" " \
  "MAINAINER=\"Test <email@example>\" " \
  "DESCRIPTION=Testapp " \
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

if [[ -z "$VERSION" ]]; then
  usage
fi

echo "Package: $NAME" > control
echo "Version: $VERSION" >> control
echo "Section: base" >> control
echo "Priority: optional" >> control
echo "Architecture: $PLATFORM" >> control
echo "Depends: $DEPENDENCIES" >> control
echo "Maintainer: $MAINAINER" >> control
echo "Description: $DESCRIPTION" >> control
