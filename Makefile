
export IMAGE_VERSION=3.1.402
export IMAGE_NAME=chrisgarrett/dotnet-dev
export DOTNET_VERSION=3.1-focal
export DOCKERIZE_VERSION=v0.6.1
export NODE_VERSION=v12.18.3

all: build

prep:
	envsubst < ./templates/Dockerfile.template > Dockerfile
	envsubst < ./templates/README.md.template > README.md

build: prep
	docker build --rm=true -t ${IMAGE_NAME}:${IMAGE_VERSION} .

create:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make create

compile:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make build

run:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} make run

bash:
	docker run --rm -it -v `pwd`/src:/work/app/src ${IMAGE_NAME}:${IMAGE_VERSION} bash
