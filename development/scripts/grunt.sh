#!/bin/bash

docker exec -it terrama2_webapp grunt
docker exec -it terrama2_webmonitor bash -c 'cd /opt/terrama2/codebase/webcomponents/ && grunt'
docker exec -it terrama2_webmonitor grunt