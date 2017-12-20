#!/bin/sh
# cloning and building apache code

git clone https://${SERVER_USERNAME}:${SERVER_PASSWORD}@code.linksmart.eu/scm/${REPO} -b ${branch} code

cd code

mvn site
mvn site:deploy
