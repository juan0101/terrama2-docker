#!/bin/bash

./configure-version.sh

./install-packages.sh

sudo docker volume create terrama2_shared_vol

sudo docker-compose -p terrama2 up -d

./config-report.sh
./config-postgres.sh
./config-nginx.sh