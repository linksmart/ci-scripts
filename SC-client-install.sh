#!/bin/sh

#####################################
## Note: generate client			#
## if already exists: rm -R client	#
#####################################
echo "moving to /data/client/java/"
cd /data/client/java/

echo "creating clients"
mvn install

echo "renaming the clients"
sed -i '0,/<groupId>io.swagger<\/groupId>/ s/<groupId>io.swagger<\/groupId>/<groupId>eu.linksmart.tools.registration<\/groupId>/' 'client/pom.xml';
sed -i '0,/<artifactId>swagger-java-client<\/artifactId>/ s/<artifactId>swagger-java-client<\/artifactId>/<artifactId>service-catalog-client<\/artifactId>/' 'client/pom.xml';
sed -i '0,/<name>swagger-java-client<\/name>/ s/<name>swagger-java-client<\/name>/<name>service-catalog-client<\/name>/' 'client/pom.xml';
sed -i s/'<version>1.0.0<\/version>'/'<version>'`jq -r .info.version /data/apidoc/swagger.json`'<\/version>'/ 'client/pom.xml' ;

echo "add javadoc dependency javax.annotation"
sed -i 's/<artifactId>maven-javadoc-plugin<\/artifactId>/<artifactId>maven-javadoc-plugin<\/artifactId><configuration><additionalDependencies><additionalDependency><groupId>javax.annotation<\/groupId><artifactId>javax.annotation-api<\/artifactId><version>1.3.2<\/version><\/additionalDependency><\/additionalDependencies><\/configuration>/g' 'client/pom.xml'

echo "moving to /data/client/java/client"
cd /data/client/java/client

echo "installing"
mvn install

#mvn deploy:deploy-file -D"pomFile=pom.xml" -Dfile=target\service-catalog-client-`jq -r .info.version ../../apidoc/swagger.json`.jar  -D"repositoryId=releases" -"Durl=https://nexus.linksmart.eu/repository/maven-releases/";
