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
ENV PORT=${PORT}
ENV UDPXY_BUFFER=2048
ENV UDPXY_RENEW=0

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
