#!/usr/bin/env bash

set -u

if [ -z "$RSFSV_INSTANCE" ]; then
    echo "RSFSV_INSTANCE environment variable is not set." >&2
    exit 1
fi

export RSFSV_CURRENT_PV_AREA_PREFIX=RSFSV_${RSFSV_INSTANCE}_PV_AREA_PREFIX
export RSFSV_CURRENT_PV_DEVICE_PREFIX=RSFSV_${RSFSV_INSTANCE}_PV_DEVICE_PREFIX
export RSFSV_CURRENT_DEVICE_IP=RSFSV_${RSFSV_INSTANCE}_DEVICE_IP
# Only works with bash
export EPICS_PV_AREA_PREFIX=${!RSFSV_CURRENT_PV_AREA_PREFIX}
export EPICS_PV_DEVICE_PREFIX=${!RSFSV_CURRENT_PV_DEVICE_PREFIX}
export EPICS_DEVICE_IP=${!RSFSV_CURRENT_DEVICE_IP}

# Create volume for autosave and ignore errors
/usr/bin/docker create \
    -v /opt/epics/startup/ioc/rsfsv-epics-ioc/iocBoot/iocrsfsv/autosave \
    --name rsfsv-epics-ioc-${RSFSV_INSTANCE}-volume \
    lnlsdig/rsfsv-epics-ioc:${IMAGE_VERSION} \
    2>/dev/null || true

# Remove a possible old and stopped container with
# the same name
/usr/bin/docker rm \
    rsfsv-epics-ioc-${RSFSV_INSTANCE} || true

/usr/bin/docker run \
    --net host \
    -t \
    --rm \
    --volumes-from rsfsv-epics-ioc-${RSFSV_INSTANCE}-volume \
    --name rsfsv-epics-ioc-${RSFSV_INSTANCE} \
    lnlsdig/rsfsv-epics-ioc:${IMAGE_VERSION} \
    -i "${EPICS_DEVICE_IP}" \
    -P "${EPICS_PV_AREA_PREFIX}" \
    -R "${EPICS_PV_DEVICE_PREFIX}" \
