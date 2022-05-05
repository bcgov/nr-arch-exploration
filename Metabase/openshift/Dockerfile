FROM docker.io/openjdk:17-alpine
WORKDIR /app
COPY /ojdbc8-full/ /app/plugins/
ARG METABASE_VERSION
ARG DB_HOST
ARG DB_PORT
ENV DB_HOST_PORT=$DB_HOST:$DB_PORT
ENV METABASE_VER=$METABASE_VERSION
ENV FC_LANG=en-US \
  LC_CTYPE=en_US.UTF-8
RUN apk add --update --no-cache bash curl wget ttf-dejavu fontconfig
RUN wget -q http://downloads.metabase.com/${METABASE_VER}/metabase.jar \
&& chmod -R 777 /app

COPY InstallCert.java .
RUN javac InstallCert.java
RUN java InstallCert --quiet ${DB_HOST_PORT}
RUN keytool -exportcert -alias "$DB_HOST-1" -keystore jssecacerts -storepass changeit -file /opt/oracle.cer
RUN keytool -importcert -alias orakey -noprompt -keystore ${JAVA_HOME}/lib/security/cacerts -storepass changeit -file /opt/oracle.cer
EXPOSE 3000
ENTRYPOINT ["java", "-jar", "metabase.jar"]
