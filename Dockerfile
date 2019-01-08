FROM microsoft/dotnet:2.2-sdk
MAINTAINER Chris Garrett (https://github.com/chris-garrett/docker-dotnet-dev)
LABEL description=".Net Core development image 2.2-2019.01.07"

ARG DOCKERIZE_VERSION=v0.6.0

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV NODE_HOME="/opt/node-v10.15.0"
ENV PATH="/opt/node-v10.15.0/bin:/opt/jdk1.8.0_191/bin:/opt/pdi-ce-8.1.0.0-365:/opt/go-1.8/bin:/opt/node-v10.13.0-linux-x64/bin:/home/chris/projects/mackware/go/bin:/opt/go-1.8/bin:/home/chris/bin:/home/chris/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

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
  && wget https://github.com/jwilder/dockerize/releases/download/v0.6.0/dockerize-linux-amd64-v0.6.0.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.0.tar.gz \
  && rm dockerize-linux-amd64-v0.6.0.tar.gz \
  && wget https://nodejs.org/dist/v10.15.0/node-v10.15.0-linux-x64.tar.xz \
  && pwd \
  && ls -la \
  && tar -vxf node-v10.15.0-linux-x64.tar.xz \
  && mv node-v10.15.0-linux-x64 /opt/node-v10.15.0 \
  && rm node-v10.15.0-linux-x64.tar.xz

WORKDIR /work/app/src
EXPOSE 5000
USER sprout
