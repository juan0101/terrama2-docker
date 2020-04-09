#!/bin/bash

sh ./configure-version.sh

sh ./install-packages.sh

sh ./config-nginx.sh
sh ./config-postgres.sh
sh ./config-report.sh

sudo docker volume create terrama2_shared_vol

sudo docker-compose -p terrama2 up -d
