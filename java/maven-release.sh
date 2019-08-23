#!/bin/sh -iv

# deploying artifacts in nexus
mvn deploy

# configuring git
git config --global user.email 'travis@travis-ci.org'
git config --global user.name 'Travis CI'

# moving realocate head
git branch tmp
git checkout release
git merge tmp
git branch -d tmp

# tagging release
git tag v$ARTIFACT_VERSION
git commit -am \"[skip travis] AUTOMATIC COMMIT: tagging version\"

# prepearign master for new snapshot version
git fetch origin master:master
git branch -a
git checkout master
git merge release
python3 .versionScript.py
git commit -am \"[skip travis] AUTOMATIC COMMIT: preparing new SNAPSHOT\"

# commit all changes and tags
git push https://${GH_TOKEN}@github.com/linksmart/linksmart-java-utils.git --all
git push https://${GH_TOKEN}@github.com/linksmart/linksmart-java-utils.git --tags