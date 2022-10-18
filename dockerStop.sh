#!/usr/bin/env bash
docker-compose -f docker-compose-traefik.yaml --env-file docker-compose-traefik.env -p open-api  down -v