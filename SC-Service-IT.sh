#!/bin/sh

echo "testing"
cd /data/sc/integration-test/registration3rdService

mvn -B -Dtest=* -D'ls.sc.version'=`jq -r .info.version /data/sc/apidoc/swagger.json` test
