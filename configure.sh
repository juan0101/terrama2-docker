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
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

sudo apt-fast update

sudo apt-fast install docker-ce docker-ce-cli containerd.io git code

sudo usermod -aG docker $USER

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

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

cp -a report_client/environment.ts ~/mydevel/terrama2-report/src/environments/environment.ts
cp -a report_client/environment.prod.ts ~/mydevel/terrama2-report/src/environments/environment.prod.ts

cp -a report_server/config/config.json ~/mydevel/terrama2-report-server/config/config.json
cp -a report_server/geoserver-conf/config.json ~/mydevel/terrama2-report-server/geoserver-conf/config.json

cp -r webmonitor/instances/ ~/mydevel/terrama2/codebase/webmonitor/config/

cp -a webapp/db.json ~/mydevel/terrama2/codebase/webapp/config/db.json
cp -a webapp/settings.json ~/mydevel/terrama2/codebase/webapp/config/settings.json

cp -a terrama2/version.json ~/mydevel/terrama2/codebase/share/terrama2/version.json

docker volume create terrama2_shared_vol

sudo chmod +x terrama2_node_8/install.sh
sudo chmod +x terrama2_node_8/build.sh

sudo chmod +x scripts/npm-install.sh
sudo chmod +x scripts/grunt.sh

echo "******************"
echo "* Building image *"
echo "******************"
echo ""

cd terrama2_node_8/

docker build -t terrama2_node_8 .

cd ..

echo "**************************"
echo "* Running docker compose *"
echo "**************************"
echo ""

docker-compose -p terrama2 up -d

docker exec -it terrama2_webapp /build.sh

sudo chown $USER:$USER -R ~/mydevel/3rdparty
sudo chown $USER:$USER -R ~/mydevel/build
sudo chown $USER:$USER -R ~/mydevel/mylibs

xhost +local:docker

echo -e '
127.0.0.1       terrama2_geoserver
127.0.0.1       terrama2_webapp
127.0.0.1       terrama2_webmonitor' | sudo tee -a /etc/hosts > /dev/null

mkdir ~/mydevel/terrama2/codebase/.vscode
touch ~/mydevel/terrama2/codebase/.vscode/launch.json
echo -e "
{
    \"version\": \"0.2.0\",
    \"configurations\": [
        {
            \"name\": \"Admin\",
            \"address\": \"0.0.0.0\",
            \"type\": \"node\",
            \"request\": \"attach\",
            \"localRoot\": \"${workspaceFolder}/webapp\",
            \"remoteRoot\": \"/opt/terrama2/codebase/webapp\",
            \"port\": 5858,
            \"restart\": true,
            \"sourceMaps\": false,
            \"protocol\": \"inspector\"
        },
        {
            \"name\": \"Monitor\",
            \"address\": \"localhost\",
            \"type\": \"node\",
            \"request\": \"attach\",
            \"localRoot\": \"${workspaceFolder}/webmonitor\",
            \"remoteRoot\": \"/opt/terrama2/codebase/webmonitor\",
            \"port\": 5859,
            \"restart\": false,
            \"sourceMaps\": false,
            \"protocol\": \"inspector\"
        }
    ]
}" > ~/mydevel/terrama2/codebase/.vscode/launch.json