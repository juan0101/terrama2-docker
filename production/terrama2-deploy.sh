#!/bin/bash

docker volume create terrama2_shared_vol

./configure-version.sh

docker-compose -p terrama2 up -d

docker network connect terrama2_net terrama2_geoserver
docker network connect terrama2_net terrama2_pg
