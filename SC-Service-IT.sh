#!/bin/sh

echo "testing"
cd /data/integration-test/registration3rdService

mvn -Dtest=* -D'ls.sc.version'=`jq -r .info.version /data/sc/apidoc/swagger.json` test
