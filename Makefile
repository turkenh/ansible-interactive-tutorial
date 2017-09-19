USER=turkenh

.DEFAULT_GOAL := all

build:
	docker build -t $(USER)/${IMAGE} -f images/${IMAGE}/Dockerfile .

push:
	docker push $(USER)/${IMAGE}

build_and_push: build push

all:
	IMAGE=ubuntu-1404-ansible-docker-host $(MAKE) build_and_push
	IMAGE=ubuntu-1604-ansible-docker-host $(MAKE) build_and_push
	IMAGE=ansible-tutorial $(MAKE) build_and_push
