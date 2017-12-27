#!/bin/sh

#####################################
## Note: generate client			#
## if already exists: rm -R client	#
#####################################
cd data 

mvn install

sed -i '0,/<groupId>io.swagger<\/groupId>/ s/<groupId>io.swagger<\/groupId>/<groupId>eu.linksmart.tools.registration<\/groupId>/' 'client/pom.xml';
sed -i '0,/<artifactId>swagger-java-client<\/artifactId>/ s/<artifactId>swagger-java-client<\/artifactId>/<artifactId>service-catalog-client<\/artifactId>/' 'client/pom.xml';
sed -i '0,/<name>swagger-java-client<\/name>/ s/<name>swagger-java-client<\/name>/<name>service-catalog-client<\/name>/' 'client/pom.xml';
sed -i s/'<version>1.0.0<\/version>'/'<version>'`jq -r .info.version ../../apidoc/swagger.json`'<\/version>'/ 'client/pom.xml' ;

cd client;

mvn deploy:deploy-file -D"pomFile=pom.xml" -D"file=target\service-catalog-client-2.2.jar"  -D"repositoryId=releases" -"Durl=https://nexus.linksmart.eu/repository/maven-releases/";
