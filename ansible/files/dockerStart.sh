#!/usr/bin/env bash

#build open api specfile
npm run build

#stop existing
./dockerStop.sh

#start
docker-compose -p open-api --env-file docker.env pull
docker-compose -p open-api --env-file docker.env build
docker-compose -p open-api --env-file docker.env up -d