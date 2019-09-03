#!/bin/sh -e

git clone https://github.com/linksmart/ci-scripts.git ci
echo "copying maven configuration files  ..."
cp -ar ci/java/.mvn .
cp ci/java/.travis.settings.xml .

echo "copying ci scripts  ..."
cp ci/git-realocate-head.sh .
cp ci/java/versionScript.py .
cp ci/java/maven-release.sh .

echo "granting execution rights ..."
chmod +x *.sh

echo "realocating head ..."
. git-realocate-head.sh

if [ "$TRAVIS_BRANCH" = "release" ]
 then
   echo "releasing..."
   export ARTIFACT_VERSION=`python3 versionScript.py`
   [ ! "$ARTIFACT_VERSION" ] && exit 1
fi