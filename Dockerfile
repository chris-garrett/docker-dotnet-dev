FROM mcr.microsoft.com/dotnet/sdk:6.0.400-alpine3.16
LABEL maintainer="Chris Garrett (https://github.com/chris-garrett/docker-dotnet-dev)"
LABEL description=".Net Core development image 6.0.400"

ARG DOWNLOADS=/root/downloads
ARG DIRS= \
  /home/sprout/.config \
  /home/sprout/.dotnet \
  /home/sprout/.local \  
  /home/sprout/.npm \
  /home/sprout/.nuget

ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://+:5000
ENV DOTNET_ENVIRONMENT=Development
ENV DOTNET_NOLOGO=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV NODE_HOME=/opt/node-v16.17.0-linux-x64-musl
ENV PATH=$PATH:/home/sprout/.dotnet/tools:$NODE_HOME/bin

COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc

RUN \
  set -x \
  && apk add --no-cache \
    git \
    make \
    bash \
  && mkdir -p $DOWNLOADS \
  # dockerize
  && curl -L -o $DOWNLOADS/dockerize-linux-amd64-v0.6.1.tar.gz https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
  && tar -xf $DOWNLOADS/dockerize-linux-amd64-v0.6.1.tar.gz -C /usr/local/bin \
  # task
  && curl -L -o $DOWNLOADS/task_v3.9.2_linux_amd64.tar.gz https://github.com/go-task/task/releases/download/v3.9.2/task_linux_amd64.tar.gz \
  && tar -C /usr/local/bin -xzvf $DOWNLOADS/task_v3.9.2_linux_amd64.tar.gz \  
  # node
  && curl -L -o $DOWNLOADS/node-v16.17.0-linux-x64-musl.tar.xz https://unofficial-builds.nodejs.org/download/release/v16.17.0/node-v16.17.0-linux-x64-musl.tar.xz \
  && tar -C /opt -xf $DOWNLOADS/node-v16.17.0-linux-x64-musl.tar.xz \  
  # glic
  && curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && curl -L -o $DOWNLOADS/glibc-2.35-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk \
  && apk add $DOWNLOADS/glibc-2.35-r0.apk \  
  # cleanup manual installs
  && rm -fr $DOWNLOADS \
  # install npm tools
  && npm config set user 0 \
  && npm install -g yarn serverless nodemon \
  # install dotnet tools
  && dotnet tool install --global dotnet-ef --version 6.0.0 \
  && dotnet tool install --global Amazon.Lambda.Tools --version 5.2.0 \
  # create non-root user, directories and update permissions
  && adduser -s /bin/bash -D sprout \
  && cp -R /root/.dotnet /home/sprout/.dotnet \
  && cp -R /root/.local /home/sprout/.local \
  && cp -R /root/.nuget /home/sprout/.nuget \
  && mkdir -p \
    $DIRS \
    /work/app/src \
    /work/data \
  && chown -R sprout:sprout \
    /home/sprout \
    /home/sprout/.bashrc \
    /home/sprout/.vimrc \
    $DIRS \
    /work

WORKDIR /work/app
EXPOSE 5000
USER sprout
