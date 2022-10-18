#!/usr/bin/env bash

#build open api specfile
npm run build

cp ../../dist/openapi.yaml openapi
cp ../../dist/openapi.yaml nginx/content/openapi.yaml


#stop existing
./dockerStop.sh

#start
docker-compose -p open-api  pull
docker-compose -p open-api  build
docker-compose -p open-api  up -d