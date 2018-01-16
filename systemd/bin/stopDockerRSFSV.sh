#!/usr/bin/env bash

set -u

if [ -z "$RSFSV_INSTANCE" ]; then
    echo "RSFSV_INSTANCE environment variable is not set." >&2
    exit 1
fi

/usr/bin/docker stop \
    rsfsv-epics-ioc-${RSFSV_INSTANCE}
