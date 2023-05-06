FROM mcr.microsoft.com/dotnet/sdk:7.0.203-alpine3.17
LABEL maintainer="Chris Garrett (https://github.com/chris-garrett/docker-dotnet-dev)"
LABEL description=".Net Core development image 7.0.203"

ARG DOWNLOADS=/root/downloads
ARG DIRS= \
  /home/sprout/.config \
  /home/sprout/.dotnet \
  /home/sprout/.local \  
  /home/sprout/.npm \
  /home/sprout/.nuget

ENV HOST_ENVIRONMENT=container
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://+:5000
ENV DOTNET_ENVIRONMENT=Development
ENV DOTNET_NOLOGO=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV NODE_HOME=/opt/node-v18.16.0-linux-x64-musl
ENV PATH=$PATH:/home/sprout/.dotnet/tools:$NODE_HOME/bin

COPY ./bash_aliases /home/sprout/.bashrc
COPY ./vimrc /home/sprout/.vimrc

RUN \
  set -x \
  && apk update \
  && apk upgrade -U \
  && apk add --no-cache \
    git \
    make \
    bash \
    icu-libs \
    icu-data-full \
    tzdata \
  && mkdir -p $DOWNLOADS /tools \
  # dockerize
  && curl -L -o $DOWNLOADS/dockerize-linux-amd64-v0.6.1.tar.gz https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
  && tar -xf $DOWNLOADS/dockerize-linux-amd64-v0.6.1.tar.gz -C /usr/local/bin \
  # task
  && curl -L -o $DOWNLOADS/task_v3.24.0_linux_amd64.tar.gz https://github.com/go-task/task/releases/download/v3.24.0/task_linux_amd64.tar.gz \
  && tar -C /usr/local/bin -xzvf $DOWNLOADS/task_v3.24.0_linux_amd64.tar.gz \  
  # node
  && curl -L -o $DOWNLOADS/node-v18.16.0-linux-x64-musl.tar.xz https://unofficial-builds.nodejs.org/download/release/v18.16.0/node-v18.16.0-linux-x64-musl.tar.xz \
  && tar -C /opt -xf $DOWNLOADS/node-v18.16.0-linux-x64-musl.tar.xz \  
  # glibc
  && curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && curl -L -o $DOWNLOADS/glibc-2.35-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk \
  # broken as of 3.16. work around is: https://github.com/sgerrand/alpine-pkg-glibc/issues/185#issuecomment-1261935191
  && apk add --force-overwrite $DOWNLOADS/glibc-2.35-r0.apk \
  && apk fix --force-overwrite alpine-baselayout-data \
  # https://github.com/sgerrand/alpine-pkg-glibc/issues/181
  && mkdir -p /lib64 \
  && ln -sf /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2 \
  # cleanup manual installs
  && rm -fr $DOWNLOADS \
  # install npm tools
  && npm install -g yarn serverless nodemon \
  # install dotnet tools
  && dotnet tool install --tool-path=/tools dotnet-depends --version 0.7.0 \
  && dotnet tool install --tool-path=/tools dotnet-counters --version 7.0.421201 \
  && dotnet tool install --tool-path=/tools dotnet-dump --version 7.0.421201 \
  && dotnet tool install --tool-path=/tools dotnet-symbol --version 1.0.415602 \
  && dotnet tool install --tool-path=/tools dotnet-trace --version 7.0.421201 \
  && dotnet tool install --tool-path=/tools dotnet-ef --version 7.0.5 \
  && dotnet tool install --tool-path=/tools Amazon.Lambda.Tools --version 5.6.6 \
  # install jetbrains tools
  && mkdir -p /tools/dotmemory /tools/dottrace \
  && curl -L -o /tmp/dotmemory.tgz https://download.jetbrains.com/resharper/dotUltimate.2023.1.1/JetBrains.dotMemory.Console.linux-musl-x64.2023.1.1.tar.gz \
  && tar -C /tools/dotmemory -xf /tmp/dotmemory.tgz \
  && rm -fr /tmp/dotmemory.tgz \
  && curl -L -o /tmp/dottrace.tgz https://download.jetbrains.com/resharper/dotUltimate.2023.1.1/JetBrains.dotTrace.CommandLineTools.linux-musl-x64.2023.1.1.tar.gz \
  && tar -C /tools/dottrace -xf /tmp/dottrace.tgz \
  && rm -fr /tmp/dottrace.tgz \
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
    /work \
  # should be the last thing
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work/app
EXPOSE 5000
USER sprout
