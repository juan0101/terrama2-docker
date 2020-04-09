#!/bin/bash

sudo apt-get update

sudo apt-get -y install nginx

sudo rm -v -f /etc/nginx/sites-available/default
sudo rm -v -f /etc/nginx/sites-enabled/default

sudo cp -v nginx-config/sites-available/terrama2-default /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/terrama2-default -t /etc/nginx/sites-enabled/

sudo cp -v -r nginx-config/terrama2/ /etc/nginx/
sudo cp -v nginx-config/proxy_params /etc/nginx/
sudo cp -v nginx-config/nginx.conf /etc/nginx/
