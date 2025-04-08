CADDY_VERSION = 2.9.1
VERSION = $(shell git describe --always --tags --dirty)
REV = $(shell git rev-parse HEAD)
DOCKER_REGISTRY ?= docker.io
DOCKER_REPO ?= mwmahlberg/haddy
DOCKER_TAG ?= $(VERSION)-caddy$(CADDY_VERSION)-alpine
DOCKER_IMAGE ?= $(DOCKER_REGISTRY)/$(DOCKER_REPO):$(DOCKER_TAG)
DATE=$(shell date +%FT%T%z)
.PHONY: all image push
all: image push
image:
	docker buildx build \
	--build-arg DATE=$(DATE) \
	--build-arg REVISION=$(REV) \
	--build-arg VERSION=$(VERSION) \
	--build-arg CADDY_VERSION=$(CADDY_VERSION) \
	-t $(DOCKER_IMAGE) .
push:
	docker push $(DOCKER_IMAGE)