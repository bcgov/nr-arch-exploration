FROM docker.io/openjdk:17-alpine
WORKDIR /app
COPY /ojdbc8-full/ /app/plugins/
ARG METABASE_VERSION
ENV METABASE_VER=$METABASE_VERSION
ENV FC_LANG=en-US \
  LC_CTYPE=en_US.UTF-8
RUN apk add --update --no-cache bash curl wget ttf-dejavu fontconfig
RUN wget -q http://downloads.metabase.com/${METABASE_VER}/metabase.jar \
&& chmod -R 777 /app

COPY startup.sh .
COPY InstallCert.class .
COPY "InstallCert\$SavingTrustManager.class" .
RUN chmod -R 777 /opt && chmod -R 777 /etc
EXPOSE 3000
USER 185
ENTRYPOINT ["sh", "startup.sh"]
