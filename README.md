# docker-dotnet-dev

.Net development image 3.1.409

## Versions
- .Net SDK 3.1.409: https://hub.docker.com/_/microsoft-dotnet-sdk//
- Dockerize v0.6.1: https://github.com/jwilder/dockerize
- Node.js v14.17.0: https://nodejs.org/en/
- Task v3.4.2: https://github.com/go-task
- Entity Framework Cli (dotnet-ef): https://docs.microsoft.com/en-us/ef/core/cli/dotnet
- Serverless: https://www.serverless.com 

## Usage

Basic usage:
```
docker run --rm \
  -v `pwd`/src:/work/app/src \
  chrisgarrett/dotnet-dev:3.1.409 \
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
  chrisgarrett/dotnet-dev:3.1.409 \
  dotnet create reactredux
```

## Credits
