#!/bin/bash

sudo apt-get install git

mkdir ~/mydevel

# git clone -b b4.1.0 -o upstream https://github.com/TerraMA2/terrama2.git ~/mydevel/terrama2/codebase
# GIT_SSL_NO_VERIFY=false git clone -o upstream -b 5.4.5 https://gitlab.dpi.inpe.br/terralib/terralib.git ~/mydevel/terrama2/terralib
git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report.git ~/mydevel/terrama2-report
git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report-server.git ~/mydevel/terrama2-report-server

cp -a ~/mydevel/terrama2-report/src/environments/environment.ts.example ~/mydevel/terrama2-report/src/environments/environment.ts
cp -a ~/mydevel/terrama2-report/src/environments/environment.prod.ts.example ~/mydevel/terrama2-report/src/environments/environment.prod.ts

cp -a ~/mydevel/terrama2-report-server/config/config.json.example ~/mydevel/terrama2-report-server/config/config.json
cp -a ~/mydevel/terrama2-report-server/geoserver-conf/config.json.example ~/mydevel/terrama2-report-server/geoserver-conf/config.json

docker volume create terrama2_shared_vol

sudo chmod +x terrama2/*
# sudo chmod +x scripts/*

cd terrama2_node_8/

docker build -t terrama2_node_8 .

cd ..

docker-compose -p terrama2 up -d

# cd scripts

# ./grunt.sh
# ./npm-install.sh

echo -e '
127.0.0.1       terrama2_geoserver
127.0.0.1       terrama2_webapp
127.0.0.1       terrama2_webmonitor' | sudo tee -a /etc/hosts > /dev/null

# cd terrama2

# docker build -t terrama2_build .

# docker run \
#         --rm \
#         # -it
#         -v ~/mydevel/terrama2/build/cmake/:/terrama2/build/cmake \
#         -v ~/mydevel/terrama2/3rdparty/:/terrama2/3rdparty/ \
#         -v ~/mydevel/terrama2/mylibs/:/terrama2/mylibs/ \
#         -v ~/mydevel/terrama2/codebase/:/terrama2/codebase/ \
#         -v ~/mydevel/terrama2/terralib/build/:/terrama2/terralib/build/ \
#         -v ~/mydevel/terrama2/terralib/build/cmake:/terrama2/terralib/build/cmake \
#         -v ~/mydevel/terrama2/terralib/3rdparty/:/terrama2/terralib/3rdparty/ \
#         -v ~/mydevel/terrama2/terralib/codebase/:/terrama2/terralib/codebase/ \
#         --name terrama2_build
#         terrama2_build
