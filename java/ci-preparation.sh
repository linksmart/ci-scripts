#!/bin/sh -e

git clone https://github.com/linksmart/ci-scripts.git ci
echo "copying maven configuration files and ci scripts  ..."
cp -arv ci/java/.mvn .
cp -v ci/* .
cp -v ci/java/* .
echo "granting execution rights ..."
chmod -v +x *.sh

echo "realocating head ..."
. git-realocate-head.sh

if [ "$TRAVIS_BRANCH" = "release" ]
 then
   echo "releasing..."
   export ARTIFACT_VERSION=`python3 .versionScript.py`
   [ ! "$ARTIFACT_VERSION" ] && exit 1
fi