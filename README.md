# docker-dotnet-dev

* .Net Core development image 

## Versions
- .Net Core SDK 2.1-sdk: https://hub.docker.com/r/microsoft/dotnet/
- Dockerize v0.6.0: https://github.com/jwilder/dockerize
- Node.js v8.11.2: https://nodejs.org/en/

## Usage

Basic usage:
```
docker run --rm \
  -v `pwd`/src:/work/app/src \
  chrisgarrett/dotnet-dev:2-18.05.18 \
  dotnet create reactredux
```

If you want fast start up times you will want to mount cache directores as well:
```
docker run --rm \
  -v `pwd`/src:/work/app/src \
  -v `pwd`/../cache/dotnet:/home/sprout/.dotnet \
  -v `pwd`/../cache/dotnet:/home/sprout/.nuget \
  -v `pwd`/../cache/dotnet:/home/sprout/.config \
  -v `pwd`/../cache/dotnet:/home/sprout/.npm \
  chrisgarrett/dotnet-dev:2-18.05.18 \
  dotnet create reactredux
```

## Credits
