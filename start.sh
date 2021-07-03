#!/usr/bin/env sh

if [ -z "${PORT}" ]; then
    PORT=10000
fi

if [ -z "${UDPXY_BUFFER}" ]; then
    UDPXY_BUFFER=32Kb
fi

if [ -z "${UDPXY_RENEW}" ]; then
    UDPXY_RENEW=60
fi

if [ -z "${UDPXY_CLIENTS}" ]; then
    UDPXY_CLIENTS=1000
fi

echo Starting udpxy on port ${PORT}

/usr/local/bin/udpxy -v -S -T -p ${PORT} -B ${UDPXY_BUFFER} -M ${UDPXY_RENEW} -c ${UDPXY_CLIENTS}

echo Stopping udpxy on port ${PORT}