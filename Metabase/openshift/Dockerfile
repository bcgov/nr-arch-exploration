FROM docker.io/adoptopenjdk/openjdk11:alpine-jre
WORKDIR /app
ARG METABASE_VERSION=V0.41.5
ENV METABASE_VER=$METABASE_VERSION
ENV FC_LANG=en-US \
  LC_CTYPE=en_US.UTF-8
RUN apk add --update --no-cache bash curl wget ttf-dejavu fontconfig
RUN wget -q http://downloads.metabase.com/${METABASE_VER}/metabase.jar \
&& chmod -R 777 /app
COPY ojbc11.jar /app/plugins/ojbc11.jar
EXPOSE 3000
ENTRYPOINT ["java", "-jar", "metabase.jar"]
