FROM docker.linksmart.eu/ci/maven-builder

ENV branch=dev
ENV version=""
ENV SERVER_PASSWORD=""
ENV SERVER_USERNAME=${SERVER_USERNAME}
ENV SERVER_USERNAME=pipelines
ENV REPO=la/data-processing-agent.git
ENV URL="http://dpa:8319/v2/api-docs?group=LinkSmart%20(R)%20IoT%20Learning%20Agent"
ENV FILE=api-docs.json

# add git for deployment plugin

USER root
RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*

ADD *.sh /bin/
RUN chmod -R ugo+rx /bin/
RUN chmod -R ugo+rwx /data/
RUN chown -R builder /data/

USER builder

RUN git config --global user.email "${SERVER_USERNAME}@linksmart.eu"
RUN git config --global user.name ${SERVER_USERNAME}

ENTRYPOINT []

CMD ["./maven-release.sh"]
