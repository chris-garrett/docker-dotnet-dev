FROM microsoft/dotnet:1.0.3-sdk-msbuild
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-dotnet-dev)
LABEL description=".Net Core development image 1.0.3"
RUN apt-get update && apt-get install -y \
  git \
  make \
  vim \
  wget \
  curl \
  && rm -rf /var/lib/apt/lists/*

ARG DOCKERIZE_VERSION=v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /app/src

RUN useradd -ms /bin/bash sprout

COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc
RUN chown sprout:sprout /home/sprout/.bashrc /home/sprout/.vimrc /app
RUN ln -sf /usr/bin/vim /usr/bin/vi

USER sprout

EXPOSE 3000
