FROM lnlsdig/epics-stream_2_7_7

RUN git clone https://github.com/lnls-dig/rsfsv-epics-ioc.git /opt/epics/rsfsv && \
    cd /opt/epics/rsfsv && \
    git checkout f194af01722c9c7112961950cd84baa38faf0afd && \
    sed -i -e 's|^[#]*EPICS_BASE=.*$|EPICS_BASE=/opt/epics/base|' configure/RELEASE && \
    sed -i -e 's|^SUPPORT=.*$|SUPPORT=/opt/epics/synApps_5_8/support|' configure/RELEASE && \
    sed -i -e 's|^ASYN=.*$|ASYN=$(SUPPORT)/asyn-4-26|' configure/RELEASE && \
    sed -i -e 's|^STREAM=.*$|STREAM=/opt/epics/stream|' configure/RELEASE && \
    make install

ENV EPICS_HOST_ARCH=linux-x86_64
WORKDIR /opt/epics/rsfsv/iocBoot/iocrsfsv

ENTRYPOINT ["/opt/epics/rsfsv/iocBoot/iocrsfsv/run.sh"]
