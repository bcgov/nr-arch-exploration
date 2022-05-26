FROM docker.io/openjdk:17-alpine
WORKDIR /app
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
RUN addgroup -S 185 && adduser -S 185 -G 185
COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/lib/ /deployments/lib/
COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/*.jar /deployments/
COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/app/ /deployments/app/
COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/quarkus/ /deployments/quarkus/
COPY --chown=185 apis/java/quarkus-legacy-oracle/startup.sh .
COPY --chown=185 apis/java/quarkus-legacy-oracle/InstallCert.class .
COPY --chown=185 "apis/java/quarkus-legacy-oracle/InstallCert\$SavingTrustManager.class" .
RUN chmod -R 777 /deployments && chmod -R 777 /app && chmod -R 777 /opt && chmod -R 777 /etc/ssl/certs/
EXPOSE 8000
USER 185
ENTRYPOINT ["sh", "startup.sh"]
