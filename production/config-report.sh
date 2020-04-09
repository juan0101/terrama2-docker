#!/bin/bash

sudo docker-compose -f report/docker-compose.yml -p report down --rmi all -v

sudo docker-compose -f report/docker-compose.yml -p report up --build --force-recreate -d

sudo docker image rm node:12 nginx -f

sudo docker image prune -f

sudo service nginx restart
