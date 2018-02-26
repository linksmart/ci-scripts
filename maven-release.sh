#!/bin/sh
# cloning and building apache code
cd /data/ 

git clone https://${SERVER_USERNAME}@code.linksmart.eu/scm/${REPO} -b ${branch} /data/code

cd /data/code


mvn -s /maven/settings.xml -B release:prepare -DreleaseVersion=${version} -Dlinksmart.commons.version=${linksmart_commons_version} -Dls.se.agents.version==${version} -Dpassword=${SERVER_PASSWORD} -Dusername=${SERVER_USERNAME} 
mvn -s /maven/settings.xml -B release:perform -Dgoals=deploy  -DreleaseVersion=${version} -Dlinksmart.commons.version=${linksmart_commons_version} -Dls.se.agents.version==${version} -Dpassword=${SERVER_PASSWORD} -Dusername=${SERVER_USERNAME} 
