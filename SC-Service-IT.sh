#!/bin/sh

rm -R /data/agent
git clone https://code.linksmart.eu/scm/la/data-processing-agent.git --branch dev /data/agent

rm -R /data/sc
git clone https://code.linksmart.eu/scm/sc/service-catalog.git /data/sc

echo "testing"
cd /data/sc/integration-test/registration3rdService

mvn -B -Dtest=* -D'ls.sc.version'=`jq -r .info.version /data/sc/apidoc/swagger.json` test
