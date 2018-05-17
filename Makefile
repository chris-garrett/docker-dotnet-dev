
export IMAGE_VERSION=2-18.05.16
export IMAGE_NAME=chrisgarrett/dotnet-dev
export DOTNET_VERSION=2.1-sdk
export DOCKERIZE_VERSION=v0.6.0
export NODE_VERSION=v8.11.2

PHONEY: all build create compile build run bash

all: build

build:
	envsubst < ./templates/Dockerfile.template > Dockerfile
	envsubst < ./templates/README.md.template > README.md

	docker build --rm=true -t ${IMAGE_NAME}:${IMAGE_VERSION} .

create:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make create

compile:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make build

run:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make run

bash:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} bash
