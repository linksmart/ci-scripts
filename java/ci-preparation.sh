#!/bin/sh -e

git clone https://github.com/linksmart/ci-scripts.git ci
echo "copying maven configuration files  ..."
cp -arv ci/java/.mvn .
cp -v ci/java/.travis.settings.xml .

echo "copying ci scripts  ..."
cp -v ci/git-realocate-head.sh .
cp -v ci/java/versionScript.py .
cp -v ci/java/maven-release.py .

echo "granting execution rights ..."
chmod -v +x *.sh

echo "realocating head ..."
. git-realocate-head.sh

if [ "$TRAVIS_BRANCH" = "release" ]
 then
   echo "releasing..."
   export ARTIFACT_VERSION=`python3 versionScript.py`
   [ ! "$ARTIFACT_VERSION" ] && exit 1
fi