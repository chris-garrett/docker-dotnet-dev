# docker-dotnet-dev

.Net development image 7.0.203

## Versions
- .Net SDK 7.0.203: https://hub.docker.com/_/microsoft-dotnet-sdk//
- Dockerize v0.6.1: https://github.com/jwilder/dockerize
- Node.js v18.16.0: https://nodejs.org/en/
- Task v3.24.0: https://github.com/go-task
- Entity Framework Cli (dotnet-ef): https://docs.microsoft.com/en-us/ef/core/cli/dotnet
- Serverless: https://www.serverless.com 

## Usage

Basic usage:
```
docker run --rm \
  -v `pwd`/src:/work/app/src \
  chrisgarrett/dotnet-dev:7.0.203 \
  dotnet create reactredux
```

If you want fast start up times you will want to mount cache directores as well:
```
docker run --rm \
  -v `pwd`/src:/work/app/src \
  -v `pwd`/../cache/dotnet:/home/sprout/.dotnet \
  -v `pwd`/../cache/nuget:/home/sprout/.nuget \
  -v `pwd`/../cache/configdotnet:/home/sprout/.config \
  -v `pwd`/../cache/npm:/home/sprout/.npm \
  chrisgarrett/dotnet-dev:7.0.203 \
  dotnet create reactredux
```

## Credits
