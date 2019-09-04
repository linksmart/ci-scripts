#!/bin/sh -e

git clone https://github.com/linksmart/ci-scripts.git ci
printf "copying maven configuration files  ..."
cp -ar ci/java/.mvn .
cp ci/java/.travis.settings.xml .
echo "done."

printf "copying ci scripts  ..."
cp ci/git-realocate-head.sh .
cp ci/java/versionScript.py .
cp ci/java/maven-release.sh .
echo "done."

printf "granting execution rights ..."
chmod +x *.sh
echo "done."

if [ "$1" != "" ]; then
  echo "Skipping head realoction"
else
  printf "realocating head ..."
  . git-realocate-head.sh
  echo "done."
fi


if [ "$TRAVIS_BRANCH" = "release" ]
 then
   printf "preparing releas version ... "
   export ARTIFACT_VERSION=`python3 versionScript.py`
   [ ! "$ARTIFACT_VERSION" ] && exit 1
   echo ${ARTIFACT_VERSION}
fi