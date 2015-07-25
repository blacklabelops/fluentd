#!/bin/bash -x
#
# A helper script for ENTRYPOINT.

set -e

loggly_tag="fluentd"

if [ -n "${LOGGLY_TAG}" ]; then
  loggly_tag=${LOGGLY_TAG}
fi

loggly_match="containerlog.**"

if [ -n "${LOGGLY_MATCH}" ]; then
  loggly_match=${LOGGLY_MATCH}
fi

if [ -n "${LOGGLY_TOKEN}" ]; then
  cat >> /etc/fluent/fluent.conf <<_EOF_

<match ${loggly_match}>
  type loggly
  loggly_url https://logs-01.loggly.com/inputs/${LOGGLY_TOKEN}/tag/${loggly_tag}
</match>

_EOF_
fi

# Invoke entrypoint of parent container
if [ "$1" = 'loggly' ]; then
  /etc/fluent/docker-entrypoint.sh $@
fi

exec "$@"