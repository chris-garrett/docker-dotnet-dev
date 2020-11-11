FROM mcr.microsoft.com/dotnet/sdk:5.0.100-focal
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-dotnet-dev)
LABEL description=".Net 5.0.100-focal Core development image 5.0.100"

ARG DOCKERIZE_VERSION=v0.6.1

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV NODE_HOME="/opt/node-v12.19.0"
ENV PATH="/opt/node-v12.19.0/bin:/home/chris/.local/bin:/home/chris/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc

RUN set -x \
  && apt-get update && apt-get install -y \
    git \
    make \
    vim \
    wget \
    curl \
    xz-utils \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash sprout \
  && echo "export DOTNET_CLI_TELEMETRY_OPTOUT=1" >> /home/sprout/.bashrc \
  && mkdir -p \
    /work/app/src \
    /work/data \
    /home/sprout/.dotnet \
    /home/sprout/.nuget \
    /home/sprout/.config \
    /home/sprout/.npm \
  && chown -R sprout:sprout \
    /home/sprout \
    /home/sprout/.bashrc \
    /home/sprout/.vimrc \
    /home/sprout/.dotnet \
    /home/sprout/.nuget \
    /home/sprout/.config \
    /home/sprout/.npm \
    /work \
  && ln -sf /usr/bin/vim /usr/bin/vi \
  && wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz \
  && rm dockerize-linux-amd64-v0.6.1.tar.gz \
  && wget https://nodejs.org/dist/v12.19.0/node-v12.19.0-linux-x64.tar.xz \
  && tar -vxf node-v12.19.0-linux-x64.tar.xz \
  && mv node-v12.19.0-linux-x64 /opt/node-v12.19.0 \
  && rm node-v12.19.0-linux-x64.tar.xz

WORKDIR /work/app/src
EXPOSE 5000
USER sprout
