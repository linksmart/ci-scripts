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

if [[ -z "$MAINAINER" ]]; then
  usage
fi

if [[ -z "$DESCRIPTION" ]]; then
  usage
fi

if [[ -z "$VERSION" ]]; then
  usage
fi

hello=ho02123ware38384you443d34o3434ingtod38384day
re='^.*?([0-9]+.*)$'
if [[ $VERSION =~ $re ]]; then
  VERSION=${BASH_REMATCH[1]}
else
  echo "could not found a number in string";
  usage
done

echo "Package: $NAME" > control
echo "Version: $VERSION" >> control
echo "Section: base" >> control
echo "Priority: optional" >> control
echo "Architecture: $PLATFORM" >> control
if [[ -n "$DEPENDENCIES" ]]; then
  echo "Depends: $DEPENDENCIES" >> control
fi
echo "Maintainer: $MAINAINER" >> control
echo "Description: $DESCRIPTION" >> control
