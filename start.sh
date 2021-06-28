#!/usr/bin/env sh

if [ -z "${PORT}" ]; then
    PORT=10000
fi

if [ -z "${UDPXY_BUFFER}" ]; then
    UDPXY_BUFFER=4096
fi

if [ -z "${UDPXY_RENEW}" ]; then
    UDPXY_RENEW=0
fi

echo Starting udpxy on port ${PORT}

/usr/local/bin/udpxy -v -S -T -p ${PORT} -B ${UDPXY_BUFFER} -M ${UDPXY_RENEW}

echo Stopping udpxy on port ${PORT}