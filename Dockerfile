FROM docker.linksmart.eu/ci/maven-builder

ENV branch=dev
ENV version=""
ENV SERVER_PASSWORD=""
ENV SERVER_USERNAME=${SERVER_USERNAME}
ENV SERVER_USERNAME=pipelines
ENV REPO=la/data-processing-agent.git
ENV REPO=la/data-processing-agent.git
ENV URL="http://dpa:8319/v2/api-docs?group=LinkSmart%20(R)%20IoT%20Learning%20Agent"
ENV FILE=api-docs.json

# add git for deployment plugin

USER root
RUN apk add --no-cache curl jq git bash sed
RUN git config --global user.email "${SERVER_USERNAME}@linksmart.eu"
RUN git config --global user.name ${SERVER_USERNAME}
USER builder

ADD *.sh /scripts/

WORKDIR /scripts

ENTRYPOINT ["sh"]
CMD ["maven-release.sh"]

EXPOSE 8319
# NOTES:
#	RUN:
#  		docker run [options] <<image-name>> [command]
#   OPTIONS:
# 		Define volume for configuration file:
#			-v <</path/on/host/machine/conf>>:/config
# 		Define volume for configuration file:
#			-v <</path/on/host/machine/dep>>:/dependencies
# 		Disable/enable REST API:
#			-e api_rest_enabled=<false/true>
#		Define default broker
#			-e connection_broker_mqtt_hostname=<hostname>
#		Expose REST:
#			-p "8319:8319"
#   COMMAND:
#       Custom configuration file (volume should be defined):
#           /config/config.cfg
#
