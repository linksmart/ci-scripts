#!/bin/sh -e

# configuring git
git config --global user.email 'travis@travis-ci.org'
git config --global user.name 'Travis CI'

echo "GIT: adding pom and commit"
git add pom.xml
git commit -m "[skip travis] AUTOMATIC COMMIT: released pom"

echo "GIT: tagging (v${ARTIFACT_VERSION}) and commiting"
git tag v$ARTIFACT_VERSION

echo "Maven: deploy"
mvn deploy -B

echo "GIT: push commits and taggs (https://\${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git)"
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git --all
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git --tags

echo "Discard all changes that have not been pushed"
git reset --hard

echo "GIT: fetching remote master"
git fetch origin master:master
git branch -a

echo "GIT: checkout master and merge with release"
git checkout master
git merge release

echo "update pom.xm to next snapshot"
python3 versionScript.py
git add pom.xml
git commit -m "[skip travis] AUTOMATIC COMMIT: preparing new SNAPSHOT"

echo "GIT: push commits and taggs (https://\${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git)"
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git --all
git push https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git --tags
