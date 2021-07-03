FROM alpine:latest as builder
RUN apk update && apk add --virtual build-dependencies build-base gcc wget git tar curl
RUN curl -LO http://www.udpxy.com/download/udpxy/udpxy-src.tar.gz && \
  tar zxvf ./udpxy-src.tar.gz && \
  cd udpxy* && \
  make && make install

FROM alpine:latest
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG PORT=10000
ARG UDPXY_BUFFER=1Mb
ARG UDPXY_RENEW=60
ARG UDPXY_RCV_TMOUT=300
ARG UDPXY_DHOLD_TMOUT=5
ARG UDPXY_SREAD_TMOUT=1
ARG UDPXY_SWRITE_TMOUT=1
ARG UDPXY_ALLOW_PAUSES=enabled
ARG UDPXY_CLIENTS=10
ENV PORT=${PORT}
ENV UDPXY_BUFFER=${UDPXY_BUFFER}
ENV UDPXY_RENEW=${UDPXY_RENEW}
ENV UDPXY_RCV_TMOUT=${UDPXY_RCV_TMOUT}
ENV UDPXY_DHOLD_TMOUT=${UDPXY_DHOLD_TMOUT}
ENV UDPXY_SREAD_TMOUT=${UDPXY_SREAD_TMOUT}
ENV UDPXY_SWRITE_TMOUT=${UDPXY_SWRITE_TMOUT}
ENV UDPXY_ALLOW_PAUSES=${UDPXY_ALLOW_PAUSES}
ENV UDPXY_CLIENTS=${UDPXY_CLIENTS}

LABEL org.opencontainers.image.source https://github.com/aperim/docker-udpxy
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="UDPXY" \
  org.label-schema.description="Reflect a stream to multicast" \
  org.label-schema.url="http://www.udpxy.com/" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/aperim/docker-udpxy" \
  org.label-schema.vendor="Aperim Pty Ltd" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

EXPOSE ${PORT}

RUN adduser -h /udpxy -g "udpxy User" -s /sbin/nologin -D udpxy udpxy

COPY --from=builder /usr/local/bin/udpxy /usr/local/bin/udpxrec /usr/local/bin/
COPY --chown=udpxy:udpxy ./start.sh ./

USER udpxy

CMD ["./start.sh"]
