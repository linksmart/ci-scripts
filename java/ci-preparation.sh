#!/bin/sh -i

git clone https://github.com/linksmart/ci-scripts.git ci
cp -ar ci/java/.mvn .
cp ci/java/.travis.settings.xml .
cp ci/java/.versionScript.py .
cp ci/java/maven-release.sh .
chmod +x maven-release.sh

if [ "$TRAVIS_BRANCH" = "release" ]
 then
   export ARTIFACT_VERSION=`curl -s https://raw.githubusercontent.com/linksmart/ci-scripts/master/java/.versionScript.py | python3`
   echo "releasing..."
fi