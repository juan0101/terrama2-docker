#!/bin/bash

sudo apt-get update

sudo apt-get -y install nginx

sudo rm -v -f /etc/nginx/sites-available/default
sudo rm -v -f /etc/nginx/sites-enabled/default

sudo cp -v ./sites-available/terrama2-default /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/terrama2-default -t /etc/nginx/sites-enabled/

sudo cp -v -r terrama2/ /etc/nginx/
sudo cp -v proxy_params /etc/nginx/
sudo cp -v nginx.conf /etc/nginx/