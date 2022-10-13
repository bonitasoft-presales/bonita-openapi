#!/usr/bin/env bash

#build open api specfile
npm run build

#stop existing
./dockerStop.sh

#start
docker-compose -p open-api pull
docker-compose -p open-api build
docker-compose -p open-api up -d