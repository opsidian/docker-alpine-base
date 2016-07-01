#!/usr/bin/env bash

set -eo pipefail; [[ "$DOCKER_ENTRYPOINT_TRACE" ]] && set -x

. /etc/profile

if [[ "$(id -u)" -ne 0 ]]; then
    echo 'docker_entrypoint.sh requires root' >&2
    exit 1
fi

cat /etc/motd

echo
echo "Docker image release info:"
cat /etc/devopshacks-release

echo
echo "Run confd with prefix ${CONFD_PREFIX}"
confd -onetime -prefix ${CONFD_PREFIX} ${CONFD_OPTIONS}

[ ! -f /docker_entrypoint.sh ] || ./docker_entrypoint.sh

exec su-exec ${USER} "$@"