#!/bin/sh

if [ -z "${URL}" ]; then
	URL="http://dpa:8319/v2/api-docs?group=LinkSmart%20(R)%20IoT%20Learning%20Agent"
fi
if [ -z "${FILE}" ]; then
	FILE=api-docs.json
fi

echo "" > "${FILE}"
echo "calling endpoint ${URL} storeging in ${FILE} ...";
curl -f --stderr err "${URL}" | jq '.' > ${FILE};
cat err;
until [ -s "${FILE}" ]; do sleep 1; echo "calling endpoint ${URL} storeging in ${FILE} ..."; curl -f --stderr err "${URL}" | jq '.' > "${FILE}"; cat err; done;
git add "${FILE}"
git diff-index --quiet HEAD || git commit -m '[skip travis] AUTOMATIC COMMIT: updating Open API'
git push https://${GH_TOKEN}@github.com/linksmart/data-processing-agent.git --all