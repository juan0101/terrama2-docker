#!/bin/bash

sudo docker-compose -p report down --rmi all -v

sudo docker-compose -p report up --build --force-recreate -d

sudo docker image rm node:12 nginx -f

sudo docker image prune -f

sudo service nginx restart