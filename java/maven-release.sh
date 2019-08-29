#!/bin/sh -ev

# deploying artifacts in nexus
mvn deploy

# configuring git
git config --global user.email 'travis@travis-ci.org'
git config --global user.name 'Travis CI'

git add pom.xml
git commit -m "[skip travis] AUTOMATIC COMMIT: released pom"

# tagging release
git tag v$ARTIFACT_VERSION
git status
git add pom.xml
git status
git commit -m "[skip travis] AUTOMATIC COMMIT: tagging version"
git status

# commit all changes and tags
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git --all
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG} --tags

# prepearign master for new snapshot version
git fetch origin master:master
git branch -a
git checkout master
git merge release
python3 .versionScript.py
git add pom.xml
git commit -m "[skip travis] AUTOMATIC COMMIT: preparing new SNAPSHOT"

# commit all changes and tags
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG} --all
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG} --tags
