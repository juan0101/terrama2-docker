#!/bin/bash

# To debug each command, uncomment next line
# set -x

# Expand variables defined in file ".env" to current script execution
eval $(egrep -v '^#' .env | xargs)

for image in conf/terrama2_webapp_settings.json.in \
             terrama2/Dockerfile.in \
             webapp/Dockerfile.in \
             webmonitor/Dockerfile.in \
             nginx-config/sites-available/terrama2-default.in \
             nginx-config/terrama2/terrama2.conf.in \
             report/report-server/config.json.in \
             report/report-client/config/environment.prod.ts.in \
             report/report-server/geoserver-conf/config.json.in \
             postgres/postgresql.conf.in; do
  sed -r \
        -e 's!%%TERRAMA2_TAG%%!'"${TERRAMA2_TAG}"'!g' \
        -e 's!%%TERRAMA2_DOCKER_REGISTRY%%!'"${TERRAMA2_DOCKER_REGISTRY}"'!g' \
        -e 's!%%TERRAMA2_DNS%%!'"${TERRAMA2_DNS}"'!g' \
        -e 's!%%TERRAMA2_PREFIX%%!'"${TERRAMA2_PREFIX}"'!g' \
        -e 's!%%PG_MAX_CONN%%!'"${PG_MAX_CONN}"'!g' \
      "${image}" > "${image::-3}"
done
