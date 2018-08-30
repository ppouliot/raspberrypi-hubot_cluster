#FROM resin/raspberry-pi-alpine:latest
FROM arm32v6/alpine:latest
MAINTAINER Peter J. Pouliot <peter@pouliot.net>

RUN adduser -D ircd -s /bin/false ircd

RUN apk --update add \
  ca-certificates gcc git libc-dev make openssl-dev tar wget \
  && rm -rf /var/cache/apk/*

RUN mkdir -p /data/log /data/lib /data/run \
  && chown -R ircd.ircd /data

RUN git clone https://github.com/ircd-hybrid/ircd-hybrid \
  && cd ircd-hybrid* \
  && ./configure --prefix / \
                 --exec-prefix /usr \
                 --sysconfdir /etc/ircd-hybrid \
                 --localstatedir /data \
  && make \
  && make install \
  && cd .. \
  && rm -rf ircd-hybrid*
