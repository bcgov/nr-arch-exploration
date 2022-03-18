FROM docker.io/adoptopenjdk/openjdk11:alpine-jre
WORKDIR /app
COPY /ojdbc11-full/ /app/plugins/
ARG METABASE_VERSION=v0.41.5
ENV METABASE_VER=$METABASE_VERSION
ENV FC_LANG=en-US \
  LC_CTYPE=en_US.UTF-8
RUN apk add --update --no-cache bash curl wget ttf-dejavu fontconfig
RUN wget -q http://downloads.metabase.com/${METABASE_VER}/metabase.jar \
&& chmod -R 777 /app

COPY startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh
EXPOSE 3000
ENTRYPOINT ["/app/startup.sh"]
