ARG CADDY_VERSION=2.9.1
FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/greenpau/caddy-git

FROM caddy:${CADDY_VERSION}-alpine
VOLUME /usr/local/src
ENV REPO="https://github.com/mwmahlberg/haddy-demosite.git"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=1
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo && \
    apk add --no-cache git && \
    mkdir -p /usr/local/src
ADD build.sh /usr/local/bin/build.sh
