#!/usr/bin/env bash

# stop existing stack
./dockerStop.sh

#start
docker-compose -f docker-compose.yaml -p open-api  pull
docker-compose -f docker-compose.yaml -p open-api  build
docker-compose -f docker-compose.yaml -p open-api  up -d