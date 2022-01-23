DOCKER_API_IMAGE = cr.yandex/crppd06rodpnrci2oqk8/socket-io-demo
REVISION := $(shell git rev-parse --short HEAD)
DATE = $(shell date "+%Y.%m.%d")
VERSION = ${DATE}-${REVISION}

docker_build:
	npx tsc -p .
	docker build -t $(DOCKER_API_IMAGE):$(VERSION) --file server.Dockerfile .

docker_push::
	docker push $(DOCKER_API_IMAGE):$(VERSION)
