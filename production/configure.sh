#!/bin/bash

docker volume create terrama2_shared_vol

./configure-version.sh

docker-compose -p terrama2 up -d