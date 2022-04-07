FROM docker-remote.artifacts.developer.gov.bc.ca/caddy:2.4.6-alpine as caddy-stage

EXPOSE 2015
COPY Caddyfile /etc/caddy/Caddyfile
COPY uis/vue-sample/dist /srv
