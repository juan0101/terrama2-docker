docker exec -it terrama2_webapp grunt
docker exec -it terrama2_webmonitor bash -c 'cd ../webcomponents && grunt'
docker exec -it terrama2_webmonitor grunt