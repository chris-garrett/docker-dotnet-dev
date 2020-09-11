# docker-dotnet-dev

* .Net Core development image 

## Versions
- .Net Core SDK 3.1-focal: https://hub.docker.com/r/microsoft/dotnet/
- Dockerize v0.6.1: https://github.com/jwilder/dockerize
- Node.js v12.18.3: https://nodejs.org/en/

## Usage

Basic usage:
```
docker run --rm \
  -v `pwd`/src:/work/app/src \
  chrisgarrett/dotnet-dev:3.1.402 \
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
  chrisgarrett/dotnet-dev:3.1.402 \
  dotnet create reactredux
```

## Credits
