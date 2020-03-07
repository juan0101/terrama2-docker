FROM ubuntu:16.04

COPY install.sh /install.sh

RUN /install.sh

COPY ./webmonitor/instances/ /terrama2/codebase/webmonitor/config/instances/
COPY ./webapp/db.json /terrama2/codebase/webapp/config/db.json
COPY ./webapp/settings.json /terrama2/codebase/webapp/config/settings.json