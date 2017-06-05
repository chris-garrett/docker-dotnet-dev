FROM microsoft/dotnet:1.1.2-sdk
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-dotnet-dev)
LABEL description=".Net Core development image 1.1.2"

ARG DOCKERIZE_VERSION=v0.3.0

RUN useradd -ms /bin/bash sprout

COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc

RUN set -x \
  && apt-get update && apt-get install -y \
    git \
    make \
    vim \
    wget \
    curl \
  && rm -rf /var/lib/apt/lists/* \

  && echo "export DOTNET_CLI_TELEMETRY_OPTOUT=1" >> /home/sprout/.bashrc \
  && mkdir app \
  && chown sprout:sprout /home/sprout/.bashrc /home/sprout/.vimrc /app \
  && ln -sf /usr/bin/vim /usr/bin/vi \

  && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /app/src
EXPOSE 3000
USER sprout
