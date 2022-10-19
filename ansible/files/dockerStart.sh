#!/usr/bin/env bash

# clean & build openapi pivot files
# add redoc images
npm run build

# build postman collection file
npm run package

# copy dist files to html static container
cp dist/openapi.yaml nginx/content
cp dist/postman.json nginx/content

# stop existing stack
./dockerStop.sh

#start
docker-compose -f docker-compose.yaml -p open-api  pull
docker-compose -f docker-compose.yaml -p open-api  build
docker-compose -f docker-compose.yaml -p open-api  up -d