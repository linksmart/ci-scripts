#!/bin/sh -e

git clone https://github.com/linksmart/ci-scripts.git ci
cp -ar ci/java/.mvn .
cp ci/java/.travis.settings.xml .
cp ci/java/.versionScript.py .
cp ci/java/maven-release.sh .
cp ci/git-realocate-head.sh .
chmod +x maven-release.sh
chmod +x git-realocate-head.sh

. git-realocate-head.sh

if [ "$TRAVIS_BRANCH" = "release" ]
 then
   export ARTIFACT_VERSION=`python3 .versionScript.py`
   echo "releasing..."
fi