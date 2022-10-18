#!/usr/bin/env bash

# build openapi.yaml
# add redoc images
npm run build

# build postman collection file
npm run package

# stop existing
./dockerStop.sh

#start
docker-compose -f docker-compose-traefik.yaml --env-file docker-compose-traefik.env -p open-api  pull
docker-compose -f docker-compose-traefik.yaml --env-file docker-compose-traefik.env -p open-api  build
docker-compose -f docker-compose-traefik.yaml --env-file docker-compose-traefik.env -p open-api  up -d