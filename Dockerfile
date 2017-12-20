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
RUN apk add --no-cache curl jq git bash
RUN git config --global user.email "${SERVER_USERNAME}@linksmart.eu"
RUN git config --global user.name ${SERVER_USERNAME}

ADD *.sh /scripts/
RUN chmod +x /scripts/*.sh
ENV PATH ${PATH}:/scripts

USER builder

CMD ["./maven-release.sh"]
