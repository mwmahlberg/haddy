ARG CADDY_VERSION=2.9.1
FROM caddy:${CADDY_VERSION}-builder-alpine AS builder
RUN xcaddy build \
    --with github.com/greenpau/caddy-git \
    --replace github.com/go-git/go-git/v5@v5.8.1=github.com/go-git/go-git/v5@v5.14.0 \
    --replace github.com/getkin/kin-openapi@v0.129.0=github.com/getkin/kin-openapi@v0.131.0 \
    --replace golang.org/x/crypto@v0.33.0=golang.org/x/crypto@v0.37.0  \
    --replace golang.org/x/crypto@v0.31.0=golang.org/x/crypto@v0.37.0  \
    --replace github.com/cloudflare/circle@v1.3.3=github.com/cloudflare/circl@v1.6.0 \
    --replace github.com/go-jose/go-jose/v3@v3.0.3=github.com/go-jose/go-jose/v3@v3.0.4 \
    --replace golang.org/x/net=golang.org/x/net@v0.39.0 

FROM caddy:${CADDY_VERSION}-alpine
ARG VERSION=0.0.1
ARG REVISION=dev
ARG DATE="unknown"
VOLUME /usr/local/src
ENV REPO="https://github.com/mwmahlberg/haddy-demosite.git"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=1
ENV INTERVAL=60
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN apk --no-cache upgrade && \
    apk add --no-cache git && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo && \
    mkdir -p /usr/local/src
LABEL org.opencontainers.image.created=${DATE}
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
