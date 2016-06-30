FROM alpine:3.4

ENV USER=app \
    DOCKER_ENTRYPOINT_TRACE= \
    CONFD_VERSION=0.11.0 \
    CONFD_PREFIX=/ \
    CONFD_OPTIONS="-backend env"

RUN \
    echo "Create app user and group" \
    && addgroup -g 1000 ${USER} \
    && adduser -u 1000 -D -G ${USER} -s /bin/false ${USER} \

    && echo "Install packages" \
    && apk add --no-cache \
        bash \
        su-exec \
        make \
        curl \

    && echo "Install confd" \
    && curl -sSL https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -o /bin/confd \
    && chmod +x /bin/confd \
    && mkdir -p /etc/confd/{conf.d,templates}

COPY docker_entrypoint.sh /docker_entrypoint.sh

ENTRYPOINT ["/docker_entrypoint.sh"]