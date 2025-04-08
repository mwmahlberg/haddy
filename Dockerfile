ARG CADDY_VERSION=2.9.1
FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/greenpau/caddy-git


FROM caddy:${CADDY_VERSION}-alpine
ARG VERSION=0.0.1
ARG REVISION=dev
VOLUME /usr/local/src
ENV REPO="https://github.com/mwmahlberg/haddy-demosite.git"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=1
ENV INTERVAL=60
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo && \
    apk add --no-cache git && \
    mkdir -p /usr/local/src
LABEL org.opencontainers.image.created=
LABEL org.opencontainers.image.authors="Markus Mahlberg <138420+mwmahlberg@users.noreply.github.com>"
LABEL org.opencontainers.image.url=https://github.com/mwmahlberg/haddy
LABEL org.opencontainers.image.documentation=https://github.com/mwmahlberg/haddy/wiki
LABEL org.opencontainers.image.source=https://github.com/mwmahlberg/haddy
LABEL org.opencontainers.image.version=${VERSION}-caddy${CADDY_VERSION}-alpine
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.title="Haddy"
LABEL org.opencontainers.image.description="Hugo + Caddy + Git"
ADD build.sh /usr/local/bin/build.sh
ADD Caddyfile /etc/caddy/Caddyfile
