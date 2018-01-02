#!/bin/sh

echo "testing"
cd /data/integration-test/registration
mvn -D'ls.sc.version'=`jq -r .info.version /data/apidoc/swagger.json` test
