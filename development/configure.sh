#!/bin/bash

echo "***********************"
echo "* Installing packages *"
echo "***********************"
echo ""

sudo add-apt-repository -y ppa:apt-fast/stable
sudo apt-get update
sudo apt-get install -y apt-fast

sudo apt-fast install apt-transport-https ca-certificates curl gnupg-agent software-properties-common 

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm microsoft.gpg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') \
   $(lsb_release -cs) \
   stable"

sudo apt-fast update

sudo apt-fast install docker-ce docker-ce-cli containerd.io git code

sudo usermod -aG docker $USER

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

mkdir ~/mydevel

echo "********************"
echo "* Cloning projects *"
echo "********************"
echo ""

git clone -b b4.1.0 -o upstream https://github.com/TerraMA2/terrama2.git ~/mydevel/terrama2/codebase
GIT_SSL_NO_VERIFY=false git clone -o upstream -b 5.4.5 https://gitlab.dpi.inpe.br/terralib/terralib.git ~/mydevel/terrama2/terralib/codebase

git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report.git ~/mydevel/terrama2-report
git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report-server.git ~/mydevel/terrama2-report-server

cp -a report/report_client/environment.ts ~/mydevel/terrama2-report/src/environments/environment.ts
cp -a report/report_client/environment.prod.ts ~/mydevel/terrama2-report/src/environments/environment.prod.ts

cp -a report/report_server/config/config.json ~/mydevel/terrama2-report-server/config/config.json
cp -a report/report_server/geoserver-conf/config.json ~/mydevel/terrama2-report-server/geoserver-conf/config.json

cp -r terrama2/webmonitor/instances/ ~/mydevel/terrama2/codebase/webmonitor/config/

cp -a terrama2/webapp/db.json ~/mydevel/terrama2/codebase/webapp/config/db.json
cp -a terrama2/webapp/settings.json ~/mydevel/terrama2/codebase/webapp/config/settings.json

sudo rm -f ~/mydevel/terrama2/codebase/share/terrama2/version.json

cp -a terrama2/version.json ~/mydevel/terrama2/codebase/share/terrama2/version.json

sudo chmod +x terrama2-ubuntu-16-04/install.sh
sudo chmod +x terrama2-ubuntu-16-04/build.sh

sudo chmod +x scripts/npm-install.sh
sudo chmod +x scripts/grunt.sh
sudo chmod +x scripts/qtcreator.sh

echo "******************"
echo "* Building image *"
echo "******************"
echo ""

cd terrama2-ubuntu-16-04/

docker build -t marcelopilatti/terrama2-ubuntu-16-04:1.0 .

cd ..

echo "**************************"
echo "* Running docker compose *"
echo "**************************"
echo ""

docker-compose -p terrama2_dev up -d

sudo chown $USER:$USER -R ~/mydevel/terrama2/3rdparty
sudo chmod 755 -R ~/mydevel/terrama2/3rdparty
sudo chown $USER:$USER -R ~/mydevel/terrama2/build
sudo chmod 755 -R ~/mydevel/terrama2/build
sudo chown $USER:$USER -R ~/mydevel/terrama2/mylibs
sudo chmod 755 -R ~/mydevel/terrama2/mylibs
sudo chown $USER:$USER -R ~/mydevel/geoserverDir
sudo chmod 755 -R ~/mydevel/geoserverDir
sudo chown $USER:$USER -R ~/mydevel/sharedData
sudo chmod 755 -R ~/mydevel/sharedData

sudo chmod 755 -R ~/mydevel/postgresqlData

xhost +local:docker

echo -e '
127.0.0.1       terrama2_geoserver
127.0.0.1       terrama2_webapp
127.0.0.1       terrama2_webmonitor' | sudo tee -a /etc/hosts > /dev/null