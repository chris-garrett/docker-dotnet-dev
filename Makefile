
export IMAGE_VERSION=8.0.101
export IMAGE_NAME=chrisgarrett/dotnet-dev
export DOTNET_VERSION=${IMAGE_VERSION}
export DOCKERIZE_VERSION=v0.7.0
export WATCHEXEC_VERSION=1.25.1
export NODE_VERSION=v20.11.0
export GLIBC_VERSION=2.35-r1

all: build

prep:
	envsubst '$${IMAGE_VERSION} $${IMAGE_NAME} $${DOTNET_VERSION} $${DOCKERIZE_VERSION} $${NODE_VERSION} $${WATCHEXEC_VERSION} $${GLIBC_VERSION}' \
		< ./templates/Dockerfile.template > Dockerfile
	envsubst '$${IMAGE_VERSION} $${IMAGE_NAME} $${DOTNET_VERSION} $${DOCKERIZE_VERSION} $${NODE_VERSION} $${WATCHEXEC_VERSION} $${GLIBC_VERSION}' \
		< ./templates/README.md.template > README.md

build: prep
	DOCKER_BUILDKIT=1 docker build --rm=true -t ${IMAGE_NAME}:${IMAGE_VERSION} .

create:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make create

compile:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make build

run:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make run

sh:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} bash

push:
	docker push ${IMAGE_NAME}:${IMAGE_VERSION}
