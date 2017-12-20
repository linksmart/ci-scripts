#!/bin/sh
# cloning and building apache code

git clone https://${SERVER_USERNAME}:${SERVER_PASSWORD}@code.linksmart.eu/scm/${REPO} -b ${branch} code

cd code

git checkout dev
git merge -s ours master
git checkout master
git merge dev
git reset --hard v${version}
git push -f
