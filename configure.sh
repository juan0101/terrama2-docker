#!/bin/bash

sudo apt-get update

sudo apt-get install git apt-transport-https ca-certificates curl gnupg-agent software-properties-common git

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo usermod -aG docker ${USER}

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

mkdir ~/mydevel

git clone -b b4.1.0 -o upstream https://github.com/TerraMA2/terrama2.git ~/mydevel/terrama2/codebase
GIT_SSL_NO_VERIFY=false git clone -o upstream -b 5.4.5 https://gitlab.dpi.inpe.br/terralib/terralib.git ~/mydevel/terrama2/terralib
git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report.git ~/mydevel/terrama2-report
git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report-server.git ~/mydevel/terrama2-report-server

cp -a report_client/environment.ts ~/mydevel/terrama2-report/src/environments/environment.ts
cp -a report_client/environment.prod.ts ~/mydevel/terrama2-report/src/environments/environment.prod.ts

cp -a report_server/config/config.json ~/mydevel/terrama2-report-server/config/config.json
cp -a report_server/geoserver-conf/config.json ~/mydevel/terrama2-report-server/geoserver-conf/config.json

docker volume create terrama2_shared_vol

cd terrama2_node_8/

docker build -t terrama2_node_8 .

cd ..

docker-compose -p terrama2 up -d

sudo chown $USER:$USER -R ~/mydevel

echo -e '
127.0.0.1       terrama2_geoserver
127.0.0.1       terrama2_webapp
127.0.0.1       terrama2_webmonitor' | sudo tee -a /etc/hosts > /dev/null