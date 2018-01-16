#!/usr/bin/env bash

set -u

if [ -z "$RSFSV_INSTANCE" ]; then
    echo "Device instance is not set. Please use -d option" >&2
    exit 1
fi

/usr/bin/docker stop \
    rsfsv-epics-ioc-${RSFSV_INSTANCE}
