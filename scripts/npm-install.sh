docker exec -it terrama2_webapp npm install
docker exec -it terrama2_webmonitor bash -c 'cd ../webcomponents && npm install'
docker exec -it terrama2_webmonitor npm install