# syntax = docker/dockerfile:experimental
FROM mcr.microsoft.com/dotnet/sdk:3.1.409-focal
LABEL maintainer="Chris Garrett (https://github.com/chris-garrett/docker-dotnet-dev)"
LABEL description=".Net Core development image 3.1.409"

ARG DOWNLOADS=/root/downloads

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV NODE_HOME /opt/node-v14.17.0-linux-x64
ENV PATH ${NODE_HOME}/bin:/home/sprout/.dotnet/tools:$PATH

COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc

RUN set -x \
  && rm -f /etc/apt/apt.conf.d/docker-clean \
  && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN \
  #--mount=type=cache,target=/var/cache/apt \
  #--mount=type=cache,target=/var/lib/apt \
  #--mount=type=cache,target=/root/.dotnet \
  #--mount=type=cache,target=/root/.local \
  #--mount=type=cache,target=/root/.npm \
  #--mount=type=cache,target=/root/.nuget \
  set -x \
  && apt-get update && apt-get install --no-install-recommends -yqq \
    git \
    make \
    vim \
    xz-utils \
  && ln -sf /usr/bin/vim /usr/bin/vi \
  && mkdir -p $DOWNLOADS \
  && curl -L -o $DOWNLOADS/task_v3.4.2_linux_amd64.deb https://github.com/go-task/task/releases/download/v3.4.2/task_linux_amd64.deb \
  && dpkg -i $DOWNLOADS/task_v3.4.2_linux_amd64.deb && apt install -f \
  && curl -L -o $DOWNLOADS/dockerize-linux-amd64-v0.6.1.tar.gz https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz \
  && tar -xf $DOWNLOADS/dockerize-linux-amd64-v0.6.1.tar.gz -C /usr/local/bin \
  && curl -L -o $DOWNLOADS/node-v14.17.0-linux-x64.tar.xz https://nodejs.org/dist/v14.17.0/node-v14.17.0-linux-x64.tar.xz \
  && tar -xf $DOWNLOADS/node-v14.17.0-linux-x64.tar.xz -C /opt \
  && rm -fr $DOWNLOADS \
  && npm config set user 0 \
  && npm install -g yarn serverless \
  && dotnet tool update -g dotnet-ef \
  && dotnet tool update -g Amazon.Lambda.Tools --framework netcoreapp3.1 \
  && useradd -ms /bin/bash sprout \
  && cp -R /root/.config /home/sprout/.config \
  && cp -R /root/.dotnet /home/sprout/.dotnet \
  && cp -R /root/.local /home/sprout/.local \
  && cp -R /root/.npm /home/sprout/.npm \
  && cp -R /root/.nuget /home/sprout/.nuget \
  && mkdir -p \
    /work/app/src \
    /work/data \
  && chown -R sprout:sprout \
    /home/sprout \
    /home/sprout/.bashrc \
    /home/sprout/.vimrc \
    /home/sprout/.config \
    /home/sprout/.dotnet \
    /home/sprout/.local \
    /home/sprout/.nuget \
    /home/sprout/.npm \
    /work

WORKDIR /work/app/src
EXPOSE 5000
USER sprout
