#!/bin/sh
# cloning and building apache code
#URL="http://dpa:8319/v2/api-docs?group=LinkSmart%20(R)%20IoT%20Learning%20Agent"
#FILE=api-docs.json
if [ -z ${URL} ]; then 
	URL="http://dpa:8319/v2/api-docs?group=LinkSmart%20(R)%20IoT%20Learning%20Agent"
fi
if [ -z ${FILE} ]; then 
	FILE=api-docs.json
fi

until [ -s ${FILE} ]; do 
	curl -f --stderr err ${URL} | jq '.' > ${FILE}
	cat err
	sleep 1
done;