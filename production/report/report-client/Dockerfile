FROM node:12 as node

WORKDIR /app

RUN git clone -b b1.0.0 -o upstream https://github.com/TerraMA2/terrama2-report.git . && \
    npm install

COPY ./report-client/config/environment.prod.ts /app/src/environments/environment.prod.ts
COPY ./report-client/config/environment.ts /app/src/environments/environment.ts

RUN npx ng build --prod --base-href /alerta/ --deploy-url /alerta/

FROM nginx

COPY --from=node /app/dist/terrama2-report/ /usr/share/nginx/html/alerta/
COPY ./report-client/nginx.conf /etc/nginx/conf.d/default.conf
